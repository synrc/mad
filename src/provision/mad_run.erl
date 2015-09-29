-module(mad_run).
-compile(export_all).

start(App) ->                            % run_dir > < log_dir
    mad:info("Scripting: ~p~n",[escript:script_name()]),
    {_,Status,X} = sh:run("run_erl",["-daemon",".",".","exec "++escript:script_name()++" sh"],
      binary,".",
        [{"RUN_ERL_LOG_GENERATIONS","1000"},
         {"RUN_ERL_LOG_MAXSIZE","20000000"},
         {"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> {ok,App};
         false -> mad:info("Shell Error: ~s~n",[binary_to_list(X)]), {error,X} end.

attach(_) -> mad:info("to_erl .~n"). % use like $(mad attach)

stop(_) -> {ok,[]}.

clean(_) -> [ file:delete(X) || X <- filelib:wildcard("{apps,deps}/*/ebin/**") ++
                                     filelib:wildcard("ebin/**")], {ok,[]}.

