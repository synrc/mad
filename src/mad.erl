-module(mad).
-copyright('Maxim Sokhatsky').
-include("mad.hrl").
-compile(export_all).
-export([main/1]).

main([]) -> help();
main(Params) ->

    {Other,FP} = mad_utils:fold_params(Params),
    case Other == [] of
         true -> skip;
         false -> mad:info("Unknown Command or Parameter ~p~n",[Other]), help() end,

    Cwd           = mad_utils:cwd(),
    ConfigFile    = "rebar.config",
    ConfigFileAbs = filename:join(Cwd, ConfigFile),
    Conf          = mad_utils:consult(ConfigFileAbs),
    Conf1         = mad_script:script(ConfigFileAbs, Conf, ""),

    return(bool(lists:foldl(fun (_,true) -> true;
          ({Name,Par},false) -> ?MODULE:Name(Cwd, ConfigFile, Conf1, Par) end, false, FP))).

bool(false) -> 0;
bool(_) -> 1.

%% fetch dependencies
deps(Cwd, ConfigFile, Conf, Params) ->
    mad:info("Deps Params: ~p~n",[Params]),
    case mad_utils:get_value(deps, Conf, []) of
        [] -> false;
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
    mad:info("Compile Params: ~p~n",[Params]),
    Res = case Params of
         [] -> mad_compile:'compile-deps'(Cwd, ConfigFile, Conf);
         __ -> mad_compile:deps(Cwd, Conf, ConfigFile, Params)
    end,
    case Res of
         true -> true;
         false -> mad_compile:'compile-apps'(Cwd, ConfigFile, Conf) end.

%% reltool apps resolving
plan(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Plan Params: ~p~n",[Params]),
    mad_plan:main([]).

repl(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("REPL Params: ~p~n",[Params]),
    mad_repl:main(Params,_Config).

bundle(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Bundle Params: ~p~n",[Params]),
    Name = case Params of [] -> mad_utils:cwd(); E -> E end,
    mad_bundle:main(filename:basename(Name)).

up(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Up Params: ~p~n",[Params]),
    mad_deps:up(_Config,Params).

ling(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Ling Params: ~p~n",[Params]),
    Name = case Params of [] -> mad_utils:cwd(); E -> E end,
    mad_ling:main(filename:basename(Name)).

app(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Create App Params: ~p~n",[Params]),
    mad_create:app(Params).

lib(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Create Lib Params: ~p~n",[Params]),
    mad_create:lib(Params).

clean(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Clean Params: ~p~n",[Params]),
    mad_run:clean(Params).

start(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Start Params: ~p~n",[Params]),
    mad_run:start(Params), false.

attach(_Cwd,_ConfigFileName,_Config,Params) ->
    mad_run:attach(Params), false.

stop(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Stop Params: ~p~n",[Params]),
    mad_run:stop(Params), false.

release(_Cwd,_ConfigFileName,_Config,Params) ->
    mad:info("Release Params: ~p~n",[Params]),
    mad_release:main(Params).

static(_Cwd,_ConfigFileName,Config,Params) ->
    mad:info("Compile Static Params: ~p~n",[Params]),
    mad_static:main(Config, Params).

version() -> ?VERSION.
help(Reason, Data) -> help(io_lib:format("~s ~p", [Reason, Data])).
help(Msg) -> mad:info("Error: ~s~n~n", [Msg]), help().
help() ->
    mad:info("MAD Build Tool version ~s~n",[version()]),
    mad:info("BNF: ~n"),
    mad:info("    invoke := mad params~n"),
    mad:info("    params := [] | run params ~n"),
    mad:info("       run := command [ options ]~n"),
    mad:info("   command := app | lib | deps | up | compile | release | bundle~n"),
    mad:info("              clean | start | stop | attach | repl ~n"),
    return(0).

info(Format) -> io:format(lists:concat([Format,"\r"])).
info(Format,Args) -> io:format(lists:concat([Format,"\r"]),Args).

return(X) -> X.
