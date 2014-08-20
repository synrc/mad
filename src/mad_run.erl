-module(mad_run).
-compile(export_all).

start(Params) ->
    {Res,Status,X} = sh:run("run_erl",["-daemon",".devbox/",".devbox/logs/","exec mad rep"],
      binary,".",
        [{"RUN_ERL_LOG_GENERATIONS","1000"},
         {"RUN_ERL_LOG_MAXSIZE","20000000"},
         {"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> skip;
         false -> io:format("Shell Error: ~s~n\r",[binary_to_list(X)]) end.

attach(Params) ->
    io:format("to_erl .devbox/~n").

stop(_) -> ok.
