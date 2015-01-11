-module(mad_deps).
-copyright('Sina Samavati').
-compile(export_all).

up(Params) ->
    List = case Params of
                [] -> [ F || F<- mad_repl:wildcards(["deps/*"]), filelib:is_dir(F) ];
                Apps -> [ "deps/"++A || A <- Apps ] end,
    os:cmd("git pull"),
  [ begin
    io:format("==> up: ~p~n", [F]),
    os:cmd(io_lib:format("cd ~s && git pull",[F]))
    end || F <- List ].

fetch(_, _Config, _, []) -> ok;
fetch(Cwd, Config, ConfigFile, [H|T]) when is_tuple(H) =:= false -> fetch(Cwd, Config, ConfigFile, T);
fetch(Cwd, Config, ConfigFile, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {Cmd, Uri, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co};
                         {_Cmd, _Url} ->
                             {_Cmd, _Url, "master"}
                     end,
    Cmd1 = atom_to_list(Cmd),
    Cache = mad_utils:get_value(cache, Config, deps_fetch),
    case get(Name) of
        fetched -> ok;
        _ -> fetch_dep(Cwd, Config, ConfigFile, Name, Cmd1, Uri, Co, Cache)
    end,
    fetch(Cwd, Config, ConfigFile, T).

fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache) ->

    TrunkPath = case Cache of
        deps_fetch -> filename:join([mad_utils:get_value(deps_dir,Config,"deps"),Name]);
        Dir -> filename:join([Dir,get_publisher(Uri),Name]) end,

    io:format("==> dependency: ~p tag: ~p~n\r", [Uri,Co]),

    % TODO: add "git clone --depth=1" option by @rillian

    Fast = case mad_utils:get_value(fetch_speed,Config,[]) of
                "fast_master" -> " --depth=1 ";
                    _  -> "" end,

    {R,Co1} = case Co of
        {_,Rev} ->
            {["git clone ",Fast,Uri," ",TrunkPath," && cd ",TrunkPath,
             " && git checkout \"",Rev,"\"" ],Rev};
        Master -> {["git clone ",Fast,Uri," ",TrunkPath],lists:concat([Master])} end,

    os:cmd(R),

    put(Name, fetched),

    %% check dependencies of the dependency
    TrunkConfigFile = filename:join(TrunkPath, ConfigFile),
    Conf = mad_utils:consult(TrunkConfigFile),
    Conf1 = mad_utils:script(TrunkConfigFile, Conf, Name),
    fetch(Cwd, Config, ConfigFile, mad_utils:get_value(deps, Conf1, [])),
    case Cache of
       deps_fetch -> skip;
       CacheDir -> build_dep(Cwd, Config, ConfigFile, get_publisher(Uri), Name, Cmd, Co1, CacheDir) end.

%% build dependency based on branch/tag/commit
build_dep(Cwd, Conf, _ConfFile, Publisher, Name, _Cmd, _Co, Dir) ->
    TrunkPath = filename:join([Dir, Publisher, Name]),
    DepsDir = filename:join([mad_utils:get_value(deps_dir, Conf, ["deps"]),Name]),
    os:cmd(["cp -r ", TrunkPath, " ", DepsDir]),
    ok = file:set_cwd(DepsDir),
    ok = file:set_cwd(Cwd).

%% internal
name_and_repo({Name, _, Repo}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo, _}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo}) -> {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) -> {atom_to_list(Name), Repo};
name_and_repo(Name) -> {Name,Name}.

get_publisher(Uri) ->
    case http_uri:parse(Uri, [{scheme_defaults,
            [{git, 9418}|http_uri:scheme_defaults()]}]) of
        {ok, {_, _, _, _, Path, _}} -> hd(string:tokens(Path,"/"));
        _ -> case string:tokens(Uri,":/") of
                [_Server,Publisher,_Repo] -> Publisher;
                _ -> exit(error) end end.
