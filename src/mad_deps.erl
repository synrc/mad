-module(mad_deps).

-export([path/0]).
-export([path/1]).
-export([clone/1]).
-export([paths/1]).
-export([ebins/1]).
-export([name_and_repo/1]).
-export([checkout_to/1]).

-include("mad.hrl").


path() ->
    ?DEPS_PATH.

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

paths(Deps) ->
    paths(Deps, []).

paths([], Acc) ->
    Acc;
paths([H|T], Acc) when is_tuple(H) =:= false ->
    paths(T, Acc);
paths([H|T], Acc) ->
    {Name, _} = name_and_repo(H),
    Conf = mad_utils:rebar_conf(path(Name)),
    Deps = mad_utils:get_value(deps, Conf, []),
    Acc1 = paths(Deps, []),
    paths(T, [path(Name)|Acc ++ Acc1]).

ebins(Deps) ->
    ebins(paths(Deps), []).

ebins([], Acc) ->
    Acc;
ebins([H|T], Acc) ->
    ebins(T, [filename:join(H, "ebin")|Acc]).

checkout_to({_, V}) -> V;
checkout_to(Else) -> Else.

name_and_repo({Name, _, Repo}) ->
    {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) ->
    {atom_to_list(Name), Repo}.

path(X) ->
    %% ~/.otp/deps/X
    filename:join(?DEPS_PATH, X).
