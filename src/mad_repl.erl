-module(mad_repl).
-compile(export_all).

load_config() ->
   Config = filelib:wildcard("rels/*/files/sys.config"),
   case Config of
      [] -> skip;
      File ->
            {ok,[Apps]} = file:consult(File),
            io:format("Configuration:\n\r",[]),
            [ begin 
                io:format("\t~p: ~p\n\r",[App,Cfg]),
                [ application:set_env(App,K,V) || {K,V} <- Cfg ]
            end || {App,Cfg} <- Apps ]
   end.

load_apps([]) -> [ application:start(A) ||A<-mad_plan:applist()];
load_apps(["applist"]) -> [ application:start(A) ||A<-mad_plan:applist()];
load_apps(Params) -> [application:ensure_all_started(list_to_atom(A))||A<-Params].

main(Params) -> 
    SystemPath = filelib:wildcard(code:root_dir() ++ 
              "/lib/{compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib}-*/ebin"),
    UserPath = filelib:wildcard("{apps,deps}/*/ebin"),
    code:set_path(SystemPath++UserPath),
    io:format("Applications: ~p\n\r",[mad_plan:applist()]),
    load_config(),
    user_drv:start(),
    load_apps(Params),
    case Params of
        ["applist"] -> skip;
        _ ->  timer:sleep(infinity) end.
