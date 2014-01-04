-module(mad).

-export([main/1]).
-export(['clone-deps'/1]).
-export([compile/1]).
-export(['compile-app'/1]).
-export(['compile-deps'/1]).


main([]) ->
    io:format("no args~n");
main(Args) ->
    Cwd = mad_utils:cwd(),
    code:add_path(mad_utils:ebin(Cwd)),
    Conf = mad_utils:rebar_conf(Cwd),
    Conf1 = mad_utils:script(Cwd, Conf),
    Fun = fun(F) -> F1 = list_to_atom(F), ?MODULE:F1(Conf1) end,
    lists:foreach(Fun, Args).

%% clone dependencies
'clone-deps'(Conf) ->
    case get_value(deps, Conf, []) of
        [] ->
            ok;
        Deps ->
            mad_utils:exec("mkdir", ["-p", mad_deps:container()]),
            mad_utils:exec("mkdir", ["-p", "deps"]),
            mad_deps:clone(Deps)
    end.

%% compile dependencies and the app
compile(Conf) ->
    Cwd = mad_utils:cwd(),
    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(Cwd, Conf),
    code:add_paths(LibDirs),

    %% compile dependencies
    'compile-deps'(Conf),
    %% check sub_dirs if they have something to be compiled
    SubDirs = mad_utils:sub_dirs(Cwd, Conf),
    lists:foreach(fun mad_compile:app/1, SubDirs),

    %% compile the app
    'compile-app'(Conf).

%% compile a project according to the conventions
'compile-app'(Conf) ->
    Cwd = mad_utils:cwd(),
    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(Cwd, Conf),
    code:add_paths(LibDirs),

    Dirs = [Cwd|mad_utils:sub_dirs(Cwd, Conf)],
    lists:foreach(fun mad_compile:app/1, Dirs).

'compile-deps'(Conf) ->
    mad_compile:deps(get_value(deps, Conf, [])).

get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default
    end.
