-module(mad_run).
-compile(export_all).

start(_) ->                            % run_dir > < log_dir
    {_,Status,X} = sh:run("run_erl",["-daemon",".",".","exec mad rep"],
      binary,".",
        [{"RUN_ERL_LOG_GENERATIONS","1000"},
         {"RUN_ERL_LOG_MAXSIZE","20000000"},
         {"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> skip;
         false -> mad:info("Shell Error: ~s~n",[binary_to_list(X)]), exit({error,X}) end.

attach(_) ->
    mad:info("to_erl .~n"). % use like $(mad attach)

stop(_) -> ok. % TODO: stop box

clean(_) -> [ file:delete(X) || X <- filelib:wildcard("{apps,deps}/*/ebin/**") ++
                                     filelib:wildcard("ebin/**")], false.
