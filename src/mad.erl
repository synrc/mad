-module(mad).
-copyright('Maxim Sokhatsky').
-compile(export_all).
-export([main/1]).

main([]) -> help();
main(Params) ->
    io:format("Bundle: ~p~n\r",[escript:script_name()]),

    FP = mad_utils:fold_params(Params),
    io:format("Params: ~p~n\r",[FP]),

    Cwd = mad_utils:cwd(),
    ConfigFile = "rebar.config",
    ConfigFileAbs = filename:join(Cwd, ConfigFile),
    Conf = mad_utils:consult(ConfigFileAbs),
    Conf1 = mad_script:script(ConfigFileAbs, Conf, ""),

    Fun = fun({Name,Params}) -> ?MODULE:Name(Cwd, ConfigFile, Conf1, Params) end,
    lists:foreach(Fun, FP).

%% fetch dependencies
deps(Cwd, ConfigFile, Conf, Params) ->
    io:format("Deps Params: ~p~n",[Params]),
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
    io:format("Compile Params: ~p~n\r",[Params]),
    mad_compile:'compile-deps'(Cwd, ConfigFile, Conf),
    mad_compile:'compile-apps'(Cwd, ConfigFile, Conf).

%% reltool apps resolving
plan(Cwd,ConfigFileName,Config,Params) ->
    io:format("Plan Params: ~p~n",[Params]),
    mad_repl:load(),
    mad_repl:applist().

repl(Cwd,ConfigFileName,Config,Params) ->
    io:format("Repl Params: ~p~n",[Params]),
    mad_repl:main(Params).

bundle(Cwd,ConfigFileName,Config,Params) ->
    io:format("Tool Params: ~p~n",[Params]),
    Name = case Params of [] -> mad_utils:cwd(); E -> E end,
    mad_bundle:main(filename:basename(Name)).

app(Cwd,ConfigFileName,Config,Params) ->
    io:format("Create App Params: ~p~n",[Params]),
    mad_create:app(Params).

lib(Cwd,ConfigFileName,Config,Params) ->
    io:format("Create Lib Params: ~p~n",[Params]),
    mad_create:lib(Params).

help(Reason, Data) -> help(io_lib:format("~s ~p", [Reason, Data])).
help(Msg) -> io:format("Error: ~s~n~n", [Msg]), help().
help() ->
    io:format("VXZ MAD Build Tool version 1.0~n"),
    io:format("BNF: ~n"),
    io:format("    invoke := mad params~n"),
    io:format("    params := [] | run params ~n"),
    io:format("       run := command [ help | options ]~n"),
    io:format("       cmd := app | lib | deps | compile | bundle~n"),
    io:format("              run | stop | attach | repl ~n"),
    halt().
