-module(mad_repl).
-compile(export_all).

load_config() ->
   Config = filelib:wildcard("rels/*/files/sys.config"),
   case Config of
      [] -> skip;
      File ->
            {ok,[Apps]} = file:consult(File),
            [ begin io:format("~p:~n",[App]),
              [ begin
              io:format("\t{~p,~p}~n",[K,V]),
              application:set_env(App,K,V) end || {K,V} <- Cfg ] end || {App,Cfg} <- Apps]
             end.

load_apps([]) -> [application:ensure_started(A)||A<-mad_plan:applist()];
load_apps(Params) -> [application:ensure_all_started(list_to_atom(A))||A<-Params].

main(Params) -> shell:start(), load_config(), load_apps(Params), timer:sleep(infinity).
