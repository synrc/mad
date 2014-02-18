-module(mad_deps).
-copyright('Sina Samavati').
-export([path/3,fetch/4,name_and_repo/1,checkout_to/1,get_publisher/1]).

-type directory() :: string().
-type filename() :: string().
-type name() :: atom().
-type uri() :: string().
-type version_control() :: git | hg.
-type repo() :: {version_control(), uri(), {branch | tag, string()} | string()}.
-type dependency() :: {name(), string(), repo()}.
-export_type([dependency/0]).

-spec path(string(), string(), string()) -> directory().
path(Dir,Publisher, Repo) ->
    %% ~/.mad/repos/Publisher/Repo
    filename:join([Dir, Publisher, Repo]).

-spec fetch(directory(), any(), filename(), [dependency()]) -> ok.
fetch(_, _Config, _, []) ->
    ok;
fetch(Cwd, Config, ConfigFile, [H|T]) when is_tuple(H) =:= false ->
    fetch(Cwd, Config, ConfigFile, T);
fetch(Cwd, Config, ConfigFile, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {Cmd, Uri, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    Cmd1 = atom_to_list(Cmd),
    Co1 = checkout_to(Co),
    Cache = mad_utils:get_value(cache, Config, deps_fetch),
    case get(Name) of
        fetched -> ok;
        _ -> fetch_dep(Cwd, Config, ConfigFile, Name, Cmd1, Uri, Co1, Cache)
    end,
    fetch(Cwd, Config, ConfigFile, T).

-spec fetch_dep(directory(), any(), filename(), string(), string(), uri(), any(), atom()) -> ok.
fetch_dep(Cwd, Config, ConfigFile, Name, Cmd, Uri, Co, Cache) ->

    TrunkPath = case Cache of
        deps_fetch -> filename:join([mad_utils:get_value(deps_dir,Config,"deps"),Name]);
        Dir -> path(Dir,get_publisher(Uri),Name) end,

    Opts = ["clone", Uri, TrunkPath ],
    io:format("dependency: ~s~n", [Name]),
    %% fetch
    mad_utils:exec(Cmd, Opts),
    put(Name, fetched),

    %% check dependencies of the dependency
    TrunkConfigFile = filename:join(TrunkPath, ConfigFile),
    Conf = mad_utils:consult(TrunkConfigFile),
    Conf1 = mad_utils:script(TrunkConfigFile, Conf),
    fetch(Cwd, Config, ConfigFile, mad_utils:get_value(deps, Conf1, [])),
    case Cache of
       deps_dir -> skip;
       CacheDir -> build_dep(Cwd, Config, ConfigFile, get_publisher(Uri), Name, Cmd, Co, CacheDir) end.

%% build dependency based on branch/tag/commit
-spec build_dep(directory(), any(), string(), string(), string(), string(), string(), string()) -> ok.
build_dep(Cwd, Conf, _ConfFile, Publisher, Name, Cmd, Co, Dir) ->
    TrunkPath = path(Dir, Publisher, Name),
%    DepsDir = filename:join([Cwd, "deps", Name]),
    DepsDir = mad_utils:get_value(deps_dir, Conf, ["deps"]),
    %% get a copy of dependency from trunk
    mad_utils:exec("cp", ["-r", TrunkPath, DepsDir]),
    %% change cwd to the copy of trunk and checkout to Co
    ok = file:set_cwd(DepsDir),
    mad_utils:exec(Cmd, ["checkout", lists:concat([Co])]),
    ok = file:set_cwd(Cwd).

%% internal
-spec name_and_repo(dependency()) -> {string(), repo()}.
name_and_repo({Name, _, Repo}) ->
    {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) ->
    {atom_to_list(Name), Repo}.

-spec checkout_to(term() | {any(), string}) -> term().
checkout_to({_, V}) -> V;
checkout_to(Else) -> Else.

-spec get_publisher(uri()) -> string().
get_publisher(Uri) ->
    S = [{git, 9418}|http_uri:scheme_defaults()],
    {ok, {_, _, _, _, Path, _}} = http_uri:parse(Uri, [{scheme_defaults, S}]),
    [Publisher|_] = string:tokens(Path, "/"),
    Publisher.
