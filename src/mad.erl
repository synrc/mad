-module(mad).
-copyright('Sina Samavati').
-compile(export_all).
-export([main/1]).

main([]) -> help();
main(Params) ->

    Cwd = mad_utils:cwd(),
    ConfigFile = "rebar.config",
    ConfigFileAbs = filename:join(Cwd, ConfigFile),
    Conf = mad_utils:consult(ConfigFileAbs),
    Conf1 = mad_script:script(ConfigFileAbs, Conf, ""),

    %% rebar should create deps dir in deps_dir only, this is not a list
    DepsDir = filename:join([mad_utils:get_value(deps_dir, Conf1, ["deps"]),"*","ebin"]),
    Paths = ["ebin"|filelib:wildcard(DepsDir)],
    code:add_paths(Paths),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(Cwd, Conf),
    code:add_paths(LibDirs),

    Fun = fun(F) -> Name = list_to_atom(F), ?MODULE:Name(Cwd, ConfigFile, Conf1,Params) end,
    lists:foreach(Fun, Params).

%% fetch dependencies
deps(Cwd, ConfigFile, Conf, Params) ->
    case mad_utils:get_value(deps, Conf, []) of
        [] -> ok;
        Deps ->
            Cache = mad_utils:get_value(deps_dir, Conf, deps_fetch),
            case Cache of
                deps_fetch -> skip;
                Dir -> file:make_dir(Dir) end,
            FetchDir = mad_utils:get_value(deps_dir, Conf, ["deps"]),
            file:make_dir(FetchDir),
            mad_deps:fetch(Cwd, Conf, ConfigFile, Deps)
    end.

%% compile dependencies and the app
compile(Cwd, ConfigFile, Conf, Params) ->
    mad_compile:'compile-deps'(Cwd, ConfigFile, Conf),
    mad_compile:'compile-apps'(Cwd, ConfigFile, Conf).

%% reltool apps resolving
plan(Cwd,ConfigFileName,Config,Params) ->
    mad_plan:main(mad_plan:applist()).

repl(Cwd,ConfigFileName,Config,Params) ->
    mad_console:main(Params).

help(Reason, Data) -> help(io_lib:format("~s ~p", [Reason, Data])).
help(Msg) -> io:format("Error: ~s~n~n", [Msg]), help().
help() ->
    io:format("SRC VXZ MAD Build Tool version 1.0~n"),
    io:format("mad deps compile plan start stop repl attach release ~n"),
    halt().
