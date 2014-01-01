-module(mad_deps).

-export([container/0]).
-export([path/1]).
-export([clone/1]).
-export([name_and_repo/1]).
-export([checkout_to/1]).

-include("mad.hrl").


container() ->
    %% ~/.mad/container
    ?CONTAINER_PATH.

path(X) ->
    %% ~/.mad/container/X
    filename:join(?CONTAINER_PATH, X).

clone([]) ->
    ok;
clone([H|T]) when is_tuple(H) =:= false ->
    clone(T);
clone([H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {Cmd, Url, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    Co1 = checkout_to(Co),
    case get(Name) of
        cloned ->
            ok;
        _ ->
            clone_dep(Name, Cmd, Url),
            build_dep(Name, Cmd, Co1)
    end,
    clone(T).

clone_dep(Name, Cmd, Url) ->
    TrunkPath = path(Name),
    Opts = ["clone", Url, TrunkPath],
    io:format("dependency: ~s~n", [Name]),
    %% clone
    mad_utils:exec(Cmd, Opts),
    put(Name, cloned),

    %% check dependencies of the dependency
    Conf = mad_utils:rebar_conf(TrunkPath),
    Conf1 = mad_utils:script(TrunkPath, Conf),
    clone(mad_utils:get_value(deps, Conf1, [])).

%% build dependency based on branch/tag/commit
build_dep(Name, Cmd, Co) ->
    TrunkPath = path(Name),
    Cwd = mad_utils:cwd(),
    DepPath = filename:join([Cwd, "deps", Name]),
    %% get a copy of dependency from trunk
    mad_utils:exec("cp", ["-r", TrunkPath, DepPath]),
    %% change cwd to the copy of trunk and checkout to Co
    ok = file:set_cwd(DepPath),
    mad_utils:exec(Cmd, ["checkout", Co]),
    ok = file:set_cwd(Cwd).


%% internal
name_and_repo({Name, _, Repo}) ->
    {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) ->
    {atom_to_list(Name), Repo}.

checkout_to({_, V}) -> V;
checkout_to(Else) -> Else.
