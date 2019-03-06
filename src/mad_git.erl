-module(mad_git).
-compile(export_all).

deps(_Params) ->
    case mad_utils:configs() of
      {error,E} -> {error,E};
      {ok,{ Cwd, ConfigFile, Conf }} ->
    case mad_utils:get_value(deps, Conf, []) of
        [] -> {ok,[]};
        Deps -> file:make_dir(mad_utils:get_value(deps_dir, Conf, ["deps"])),
                (mad:profile()):fetch([Cwd, Conf, ConfigFile, Deps]) end end.

fetch([Cwd, Conf, ConfigFile, Deps]) -> fetch(Cwd, Conf, ConfigFile, Deps).
fetch(_, _Config, _, []) -> false;
fetch(Cwd, Config, ConfigFile, [H|T]) when is_tuple(H) =:= false -> fetch(Cwd, Config, ConfigFile, T);
fetch(Cwd, Config, ConfigFile, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    Res = case get(Name) of
        fetched -> {ok,Name};
        _ ->
            {Cmd, Uri, Co} = case Repo of
                                 V={_, _, _}          -> V;
                                 {_Cmd, _Url, _Co, _} -> {_Cmd, _Url, _Co};
                                 {_Cmd, _Url}         -> {_Cmd, _Url, "master"};
                                 Url when is_list(Url) -> {git, Url, "master"}
                             end,
            Cmd1 = atom_to_list(Cmd),
            Cache = mad_utils:get_value(cache, Config, deps_fetch),
            fetch_dep(Cwd, Config, ConfigFile, Name, Cmd1, Uri, Co, Cache)
    end,
    case Res of
         {error,E} -> {error,E};
         {ok,_} -> fetch(Cwd, Config, ConfigFile, T) end.

get_repo([]) -> {error,"Repository unspecified."};
get_repo([Name|_]) ->
    case mad_utils:configs() of
      {error,E} -> {error,E};
      {ok,{ Cwd, File, Conf }} ->
    Res = case string:tokens(Name,"/") of
         [Org, Rep] -> {ok,Rep,lists:concat(["https://github.com/",Org,"/",Rep])};
         [Rep] -> {ok,Rep,lists:concat(["https://github.com/synrc/",Rep])};
         [] -> {error,"Repository invalid."}
    end,
    case Res of
         {error,X} -> {error,X};
         {ok,N,Uri} -> fetch_dep(Cwd,Conf,File,N,"git",Uri,[],deps_fetch,[])
    end end.

git_clone(Uri,Fast,TrunkPath,Rev) when Rev == "head"   orelse Rev == "HEAD"
                                orelse Rev == "master" orelse Rev == [] ->
    {["git clone ",Fast,Uri," ",TrunkPath],Rev};

git_clone(Uri,_Fast,TrunkPath,Rev) ->
    {["git clone ",Uri," ",TrunkPath,
      " && cd ",TrunkPath,
      " && git checkout \"",Rev,"\"" ],Rev}.

fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache) ->
    fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache, deep).
fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache, Deep) ->

    TrunkPath = case Cache of
        deps_fetch -> filename:join([mad_utils:get_value(deps_dir,Config,"deps"),Name]);
        Dir -> filename:join([Dir,get_publisher(Uri),Name]) end,

    mad:info("==> dependency: ~p tag: ~p~n", [Uri,Co]),

    Fast = case mad_utils:get_value(fetch_depth,Config,1) of
                1 -> " --depth=1 ";
                    _  -> "" end,

    {R,Co1} = case Co of
        X when is_list(X) -> git_clone(Uri,Fast,TrunkPath,X);
        {_,Rev} -> git_clone(Uri,Fast,TrunkPath,Rev);
        Master  -> git_clone(Uri,Fast,TrunkPath,Master) end,

    %mad:info("Fetch: ~s~n",[R]),

    FetchStatus = case filelib:is_dir(TrunkPath) of
                       true -> {skip,0,list_to_binary("Directory "++TrunkPath++" exists.")};
                       false -> sh:run(lists:concat(R)) end,

    case FetchStatus of
         {_,0,_} -> put(Name, fetched),

                    %% check dependencies of the dependency
                    TrunkConfigFile = filename:join(TrunkPath, ConfigFile),
                    Conf0 = mad_utils:consult(TrunkConfigFile),
                    case Conf0 of
                         {error,E} -> {error,E};
                         {ok,Conf} ->
                    Conf1 = mad_utils:script(TrunkConfigFile, Conf, Name),
                    case Deep of
                         deep -> fetch(Cwd, Config, ConfigFile, mad_utils:get_value(deps, Conf1, []));
                            _ -> skip
                    end,
                    case Cache of
                         deps_fetch -> {ok,Name};
                         CacheDir -> build_dep(Cwd, Config, ConfigFile,
                                        get_publisher(Uri), Name, Cmd, Co1, CacheDir)
                    end end;
    {_,_,FetchError} -> {error,FetchError} end.

%% build dependency based on branch/tag/commit
build_dep(Cwd, Conf, _ConfFile, Publisher, Name, _Cmd, _Co, Dir) ->
    TrunkPath = filename:join([Dir, Publisher, Name]),
    DepsDir = filename:join([mad_utils:get_value(deps_dir, Conf, ["deps"]),Name]),
    sh:run(lists:concat(["cp -r ", TrunkPath, " ", DepsDir])),
    ok = file:set_cwd(DepsDir),
    ok = file:set_cwd(Cwd),
    {ok,Name}.

%% internal
name_and_repo(X) -> mad_utils:name_and_repo(X).
get_publisher(Uri) -> case string:tokens(Uri,"@:/") of
   [_Proto,_Server,Publisher|_RepoPath] -> Publisher; _ -> core end.

upd(_,[])         -> {ok,[]};
upd(Config,[F|T]) ->
    mad:info("==> up: ~p~n", [F]),

    Deps = lists:foldl(fun([App,_,{_,_,{RefHead, RefName}}|_],Acc) ->
        case binary:match(list_to_binary(F), atom_to_binary(App,utf8)) of 
            {Pos, Len} when Pos+Len =:= length(F) -> [{RefHead,RefName}|Acc]; _ -> Acc end;
        (_,Acc) -> Acc end, [], [tuple_to_list(D) || D <- mad_utils:get_value(deps, Config, [])]),

    {_, Status, Message} = case Deps of
        [{tag,"master"}] ->
            % many configs marks master as tag even if its incorrect revision to fetch
            sh:run(lists:concat(["cd ",F," && git pull origin master && git checkout master && cd -"]));
        [{tag,Tag}] ->
            sh:run(lists:concat(["cd ",F," && git fetch origin \"+refs/tags/",Tag,":refs/tags/",Tag,"\" && git checkout tags/", Tag," && cd -"]));
        [{branch, Branch}] ->
            sh:run(lists:concat(["cd ",F," && git pull origin ",Branch," && git checkout ", Branch, " && cd -"]));
        _ -> sh:run(lists:concat(["cd ",F," && git pull && cd -"]))
    end,

    case Status of
         0 -> mad_utils:verbose(Config,Message), upd(Config,T);
         _ -> case binary:match(Message,[<<"You are not currently on a branch">>]) of
                   nomatch -> mad_utils:verbose(Config,Message), {error,Message};
                   _ -> upd(Config,T) end end.

up(Params) ->
  case mad_utils:configs() of
       {error,E} -> {error,E};
       {ok,{ _Cwd,_ConfigFileName,Config }} ->
          List = case Params of
                 [] -> [ F || F <- mad_repl:wildcards(["deps/*"]), filelib:is_dir(F) ];
                 Apps -> [ "deps/" ++ A || A <- Apps ] end ++ ["."],
          upd(Config,List)
  end.

