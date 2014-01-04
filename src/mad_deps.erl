-module(mad_deps).

-export([repos_path/0]).
-export([path/2]).
-export([clone/2]).
-export([name_and_repo/1]).
-export([checkout_to/1]).
-export([get_publisher/1]).

-define(REPOS_PATH, filename:join([mad_utils:home(), ".mad", "repos"])).

-type directory() :: string().
-type name() :: atom().
-type uri() :: string().
-type version_control() :: git | hg.
-type repo() :: {version_control(), uri(), {branch | tag, string()} | string()}.
-type dependency() :: {name(), string(), repo()}.


-spec repos_path() -> directory().
repos_path() ->
    %% ~/.mad/repos
    ?REPOS_PATH.

-spec path(string(), string()) -> directory().
path(Publisher, Repo) ->
    %% ~/.mad/repos/Publisher/Repo
    filename:join([?REPOS_PATH, Publisher, Repo]).

-spec clone(directory(), [dependency()]) -> ok.
clone(_, []) ->
    ok;
clone(Cwd, [H|T]) when is_tuple(H) =:= false ->
    clone(Cwd, T);
clone(Cwd, [H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {Cmd, Uri, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    Cmd1 = atom_to_list(Cmd),
    Co1 = checkout_to(Co),
    Publisher = get_publisher(Uri),
    case get(Name) of
        cloned ->
            ok;
        _ ->
            clone_dep(Cwd, Publisher, Name, Cmd1, Uri),
            build_dep(Cwd, Publisher, Name, Cmd1, Co1)
    end,
    clone(Cwd, T).

-spec clone_dep(directory(), string(), string(), string(), uri()) -> ok.
clone_dep(Cwd, Publisher, Name, Cmd, Uri) ->
    TrunkPath = path(Publisher, Name),
    Opts = ["clone", Uri, TrunkPath],
    io:format("dependency: ~s~n", [Name]),
    %% clone
    mad_utils:exec(Cmd, Opts),
    put(Name, cloned),

    %% check dependencies of the dependency
    Conf = mad_utils:rebar_conf(TrunkPath),
    Conf1 = mad_utils:script(TrunkPath, Conf),
    clone(Cwd, mad_utils:get_value(deps, Conf1, [])).

%% build dependency based on branch/tag/commit
-spec build_dep(directory(), string(), string(), string(), string()) -> ok.
build_dep(Cwd, Publisher, Name, Cmd, Co) ->
    TrunkPath = path(Publisher, Name),
    DepPath = filename:join([Cwd, "deps", Name]),
    %% get a copy of dependency from trunk
    mad_utils:exec("cp", ["-r", TrunkPath, DepPath]),
    %% change cwd to the copy of trunk and checkout to Co
    ok = file:set_cwd(DepPath),
    mad_utils:exec(Cmd, ["checkout", Co]),
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
