-module(mad_console).
-compile(export_all).

main(Params) ->
   Config = filelib:wildcard("rels/*/files/sys.config"),
   case Config of
      [] -> skip;
      File ->
            {ok,[Apps]} = file:consult(File),
            [  [ begin
              io:format("~p : ~p = ~p~n",[App,K,V]),
              application:set_env(App,K,V) end || {K,V} <- Cfg ]  || {App,Cfg} <- Apps]
             end,
   [application:start(A)||A<-mad_plan:applist()], user_drv:start(), timer:sleep(infinity).
