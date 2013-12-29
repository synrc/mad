-module(mad_deps).

-export([path/0]).
-export([path/1]).
-export([clone/1]).
-export([paths/1]).
-export([ebins/1]).
-export([make_dep_name/2]).
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
    Co = case Repo of
             {_, _, V} ->
                 V;
             {_, _, V, _} ->
                 V
         end,
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),
    case get(DepName) of
        cloned ->
            ok;
        _ ->
            clone_dep(H)
    end,
    clone(T).

clone_dep(Dep) ->
    {Name, Repo} = name_and_repo(Dep),
    {Cmd, Url, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),

    %% command options: clone url path/to/dep -b Branch/Tag
    DepPath = path(DepName),
    Opts = ["clone", mad_utils:https_to_git(Url), DepPath],
    io:format("dependency: ~s~n", [Name]),
    %% clone
    mad_utils:exec(Cmd, Opts),

    %% checkout to Co1
    Cwd = mad_utils:cwd(),
    ok = file:set_cwd(DepPath),
    mad_utils:exec(Cmd, ["checkout", Co1]),
    ok = file:set_cwd(Cwd),

    put(DepName, cloned),
    file:make_symlink(DepPath, filename:join([Cwd, "deps", Name])),

    %% check dependencies of the dependency
    DepPath = path(DepName),
    Conf = mad_utils:rebar_conf(DepPath),
    Conf1 = mad_utils:script(DepPath, Conf),
    clone(mad_utils:get_value(deps, Conf1, [])).

paths(Deps) ->
    paths(Deps, []).

paths([], Acc) ->
    Acc;
paths([H|T], Acc) when is_tuple(H) =:= false ->
    paths(T, Acc);
paths([H|T], Acc) ->
    {Name, Repo} = name_and_repo(H),
    Co = case Repo of
             {_, _, V} ->
                 V;
             {_, _, V, _} ->
                 V
         end,
    %% branch/tag it should checkout to
    Co1 = checkout_to(Co),
    Name1 = make_dep_name(Name, Co1),
    Conf = mad_utils:rebar_conf(path(Name1)),
    Deps = mad_utils:get_value(deps, Conf, []),
    Acc1 = paths(Deps, []),
    paths(T, [path(Name1)|Acc ++ Acc1]).

ebins(Deps) ->
    ebins(paths(Deps), []).

ebins([], Acc) ->
    Acc;
ebins([H|T], Acc) ->
    ebins(T, [filename:join(H, "ebin")|Acc]).

make_dep_name(Name, Suffix) ->
    %% Name-Suffix
    mad_utils:concat([Name, "-", Suffix]).

checkout_to({_, V}) -> V;
checkout_to(Else) -> Else.

name_and_repo({Name, _, Repo}) ->
    {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) ->
    {atom_to_list(Name), Repo}.

path(X) ->
    %% ~/.otp/deps/X
    filename:join(?DEPS_PATH, X).
