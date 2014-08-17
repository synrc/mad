-module(mad_deps).
-copyright('Sina Samavati').
-compile(export_all).

fetch(_, _Config, _, []) -> ok;
fetch(Cwd, Config, ConfigFile, [H|T]) when is_tuple(H) =:= false -> fetch(Cwd, Config, ConfigFile, T);
fetch(Cwd, Config, ConfigFile, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {Cmd, Uri, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    check_host_ip_addr(Uri),
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

    {R,Co1} = case Co of
        {_,Rev} ->
            {["git clone ",Uri," ",TrunkPath," && cd ",TrunkPath,
             " && git checkout \"",Rev,"\"" ],Rev};
        Master -> {["git clone ", Uri," ", TrunkPath ],lists:concat([Master])} end,

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

check_host_ip_addr(Uri) ->
    {_, {_, _, RepoHost, _, _, _}} = http_uri:parse(Uri, [{scheme_defaults, [{git, 9418}|http_uri:scheme_defaults()]}]),
    {GetAddrResult, GetAddrData} = inet:getaddr(RepoHost, inet),
    case GetAddrResult of
        error -> 
            {GetAddrResult6, GetAddrData6} = inet:getaddr(RepoHost, inet6),
            case GetAddrResult of
                error -> 
                io:format("==> get dependency errors: ipv4 ~p, ipv6 ~p~n", [GetAddrData, GetAddrData6]),
                exit(error);
                _ -> true
            end;
        _ -> true
    end.