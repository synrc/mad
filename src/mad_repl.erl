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

load_apps([]) -> [ application:start(A) ||A<-mad_plan:applist()];
load_apps(["applist"]) -> [ application:start(A) ||A<-mad_plan:applist()];
load_apps(Params) -> [application:ensure_all_started(list_to_atom(A))||A<-Params].

main(Params) -> 
    user_drv:start(),
    Path = filelib:wildcard(code:root_dir() ++ 
              "/lib/{compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib}-*/ebin") ++
          filelib:wildcard("{apps,deps}/*/ebin"),
    code:set_path(Path),
    error_logger:info_msg("CodePath: ~p~n\r\n",[code:get_path()]),
    load_config(), load_apps(Params),
    case Params of
        ["applist"] -> skip;
        _ ->  timer:sleep(infinity) end.
