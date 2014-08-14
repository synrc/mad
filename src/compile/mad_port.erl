-module(mad_port).
-compile(export_all).

replace_env(String, []) -> String;
replace_env(String, [{K,V}|Env]) ->
   replace_env(re:replace(String, K, V, [global, {return, list}]),Env).

compile(Dir,Config) ->
    case mad_utils:get_value(port_specs, Config, []) of
        [] -> skip;
         X -> compile_port(Dir,X,Config) end.

compile_port(Dir,Specs,Config) ->
    {_,System} = os:type(),
    filelib:ensure_dir(Dir ++ "/priv/"),
    Env = [ {Var,Val} || {Sys,Var,Val} <- mad_utils:get_value(port_env, Config, []), Sys == System ],
    [ begin 
           Template = string:join(filelib:wildcard(Dir ++ "/" ++ Files)," ") 
              ++ " CFLAGS LDFLAGS -o " ++ Dir ++ "/" ++ Out,
       Args = string:strip(replace_env(Template,Env),both,32),
       {Atom,Status,Report} = sh:run("cc",string:tokens(Args," "),binary,Dir,Env),
       case Status == 0 of
          true -> skip;
          false -> io:format("Port Compilation Error: ~p",[Report]) end
      end || {Sys,Out,Files} <- Specs, Sys == System].
