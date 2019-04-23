-module(mad_run).
-compile(export_all).

start(App) ->                            % run_dir > < log_dir
    mad:info("Scripting: ~p~n",[escript:script_name()]),
    {_,Status,X} = sh:run("run_erl",["-daemon",".",".","exec "++escript:script_name()++" sh"],
      binary,".",
        [{"RUN_ERL_LOG_GENERATIONS",application:get_env(mad,log_gens,"1000")},
         {"RUN_ERL_LOG_MAXSIZE",application:get_env(mad,log_size,"20000000")},
         {"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> {ok,App};
         false -> mad:info("Shell Error: ~s~n",[binary_to_list(X)]), {error,X} end.

attach(_) -> mad:info("to_erl . # run using $(mad attach)~n"), {ok,[]}.

stop(_) -> mad:info("echo 'init:stop().' | to_erl . # run using $(mad stop)~n"), {ok,[]}.

clean(_) -> [ file:delete(X) || X <- filelib:wildcard("{apps,deps}/*/ebin/*.beam") ++
                                     filelib:wildcard("ebin/*.beam")],
            [ file:delete(X) || X <- filelib:wildcard("c_src/**/*.o") ++
                                     filelib:wildcard("c_src/**/*.d")],  {ok,[]}.


dia(Params) ->
    App = mad_repl:local_app(),
    Plt = lists:concat([".",App,".plt"]),
    {_,S1,X1} = sh:run("dialyzer",["--build_plt","--output_plt",Plt,"--apps","."],binary,".",[{"ERL_LIBS","deps"}]),
    {_,S2,X2} = sh:run("dialyzer",["-q","ebin","--plt",Plt,"--no_native","-Werror_handling",
                   "-Wunderspecs","-Wrace_conditions","-Wno_undefined_callbacks"],binary,".",[{"ERL_LIBS","deps"}]),
    case S1 of
         0 -> case S2 of
              0 -> {ok,App};
              _ -> io:format("~s",[X2]), {error,App} end;
         _ -> io:format("~s",[X1]), {error,App} end.
