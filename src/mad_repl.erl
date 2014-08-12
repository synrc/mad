-module(mad_repl).
-compile(export_all).

load_config() ->
   Config = filelib:wildcard("rels/*/files/sys.config"),
   case Config of
      [] -> skip;
      File ->
            {ok,[Apps]} = file:consult(File),
            [  [ begin
              io:format("~p : ~p = ~p~n",[App,K,V]),
              application:set_env(App,K,V) end || {K,V} <- Cfg ]  || {App,Cfg} <- Apps]
             end.

load_apps([]) -> [application:start(A)||A<-mad_plan:applist()];
load_apps(Params) -> [application:ensure_all_started(list_to_atom(A))||A<-Params].

main(Params) -> load_config(), load_apps(Params), user_drv:start(), timer:sleep(infinity).
