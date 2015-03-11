-module(mad_deps).
-copyright('Sina Samavati').
-compile(export_all).

pull(_,[])         -> false;
pull(Config,[F|T]) ->
    io:format("==> up: ~p~n", [F]),
    {_,Status,Message} = sh:run(lists:concat(["cd ",F," && git pull && cd -"])),
    case Status of
         0 -> mad_utils:verbose(Config,Message), pull(Config,T);
         _ -> case binary:match(Message,[<<"You are not currently on a branch">>]) of
                   nomatch -> mad_utils:verbose(Config,Message), true;
                   _ -> pull(Config,T) end end.

up(Config,Params) ->
    List = case Params of
                [] -> [ F || F <- mad_repl:wildcards(["deps/*"]), filelib:is_dir(F) ];
                Apps -> [ "deps/" ++ A || A <- Apps ] end ++ ["."],
    pull(Config,List).

fetch(_, _Config, _, []) -> false;
fetch(Cwd, Config, ConfigFile, [H|T]) when is_tuple(H) =:= false -> fetch(Cwd, Config, ConfigFile, T);
fetch(Cwd, Config, ConfigFile, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    Res = case get(Name) of
        fetched -> false;
        _ ->
            {Cmd, Uri, Co} = case Repo of
                                 V={_, _, _}          -> V;
                                 {_Cmd, _Url, _Co, _} -> {_Cmd, _Url, _Co};
                                 {_Cmd, _Url}         -> {_Cmd, _Url, "master"}
                             end,
            Cmd1 = atom_to_list(Cmd),
            Cache = mad_utils:get_value(cache, Config, deps_fetch),
            fetch_dep(Cwd, Config, ConfigFile, Name, Cmd1, Uri, Co, Cache)
    end,
    case Res of
         true -> true;
         false -> fetch(Cwd, Config, ConfigFile, T) end.

git_clone(Uri,Fast,TrunkPath,Rev) when Rev == "head" orelse Rev == "HEAD" orelse Rev == "master" ->
    {["git clone ",Fast,Uri," ",TrunkPath],Rev};
git_clone(Uri,_Fast,TrunkPath,Rev) ->
    {["git clone ",Uri," ",TrunkPath," && cd ",TrunkPath," && git checkout \"",Rev,"\"" ],Rev}.

fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache) ->

    TrunkPath = case Cache of
        deps_fetch -> filename:join([mad_utils:get_value(deps_dir,Config,"deps"),Name]);
        Dir -> filename:join([Dir,get_publisher(Uri),Name]) end,

    io:format("==> dependency: ~p tag: ~p~n\r", [Uri,Co]),

    Fast = case mad_utils:get_value(fetch_speed,Config,[]) of
                fast_master -> " --depth=1 ";
                    _  -> "" end,

    {R,Co1} = case Co of
        X when is_list(X) -> git_clone(Uri,Fast,TrunkPath,X);
        {_,Rev} -> git_clone(Uri,Fast,TrunkPath,Rev);
        Master  -> git_clone(Uri,Fast,TrunkPath,Master) end,

    %io:format("Fetch: ~s~n",[R]),

    FetchStatus = case filelib:is_dir(TrunkPath) of
                       true -> {skip,0,list_to_binary("Directory "++TrunkPath++" exists.")};
                       false -> sh:run(lists:concat(R)) end,

    case FetchStatus of
         {_,0,_} -> put(Name, fetched),

                    %% check dependencies of the dependency
                    TrunkConfigFile = filename:join(TrunkPath, ConfigFile),
                    Conf = mad_utils:consult(TrunkConfigFile),
                    Conf1 = mad_utils:script(TrunkConfigFile, Conf, Name),
                    fetch(Cwd, Config, ConfigFile, mad_utils:get_value(deps, Conf1, [])),
                    case Cache of
                         deps_fetch -> false;
                         CacheDir -> build_dep(Cwd, Config, ConfigFile,
                                        get_publisher(Uri), Name, Cmd, Co1, CacheDir)
                    end;
    {_,_,FetchError} -> io:format("Fetch Error: ~s~n",[binary_to_list(FetchError)]), true end.

%% build dependency based on branch/tag/commit
build_dep(Cwd, Conf, _ConfFile, Publisher, Name, _Cmd, _Co, Dir) ->
    TrunkPath = filename:join([Dir, Publisher, Name]),
    DepsDir = filename:join([mad_utils:get_value(deps_dir, Conf, ["deps"]),Name]),
    os:cmd(["cp -r ", TrunkPath, " ", DepsDir]),
    ok = file:set_cwd(DepsDir),
    ok = file:set_cwd(Cwd),
    false.

%% internal
name_and_repo({Name, _, Repo}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo, _}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo}) -> {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) -> {atom_to_list(Name), Repo};
name_and_repo({Name, Version}) when is_list(Name) -> {Name, Version};
name_and_repo({Name, Version}) -> {atom_to_list(Name), Version};
name_and_repo(Name) -> {Name,Name}.

get_publisher(Uri) ->
    case http_uri:parse(Uri, [{scheme_defaults,
            [{git, 9418}|http_uri:scheme_defaults()]}]) of
        {ok, {_, _, _, _, Path, _}} -> hd(string:tokens(Path,"/"));
        _ -> case string:tokens(Uri,":/") of
                [_Server,Publisher,_Repo] -> Publisher;
                _ -> exit(error) end end.
