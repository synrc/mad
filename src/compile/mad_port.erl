-module(mad_port).
-copyright('Maxim Sokhatsky').
-compile(export_all).

replace_env(String, []) -> String;
replace_env(String, [{K,V}|Env]) ->
   replace_env(re:replace(String, K, V, [global, {return, list}]),Env).

compile(Dir,Config) ->
    case mad_utils:get_value(port_specs, Config, []) of
        [] -> [false];
         X -> compile_port(Dir,X,Config) end.

compile_port(Dir,Specs0,Config) ->
    {_,Flavour} = os:type(),
    System = atom_to_list(Flavour),
    Specs = [ {O,F} || {Sys,O,F} <- Specs0, Sys == System] ++
            [ {O,F} || {O,F} <- Specs0],
    filelib:ensure_dir(Dir ++ "/priv/"),
    Env =  [ {Var,Val} || {Sys,Var,Val} <- mad_utils:get_value(port_env, Config, []), Sys == System ] ++
          [ {Var,Val} || {Var,Val} <- mad_utils:get_value(port_env, Config, []) ] ++
           [{"LDFLAGS",[]},{"CFLAGS",[]}],
    [ begin
           Template = string:join(filelib:wildcard(Dir ++ "/" ++ Files)," ") 
              ++ " CFLAGS LDFLAGS -o " ++ Dir ++ "/" ++ Out,
       Args = string:strip(replace_env(Template,Env),both,32),
       %mad:info("Args: ~p~n",[Args]),
       %mad:info("Env: ~p~n",[Env]),
       {_,Status,Report} = sh:run("cc",string:tokens(Args," "),binary,Dir,Env),
       case Status of
          0 -> false;
          _ -> mad:info("Port Compilation Error:~n" ++ io_lib:format("~ts",[Report]),[]), true end
      end || {Out,Files} <- Specs ].
