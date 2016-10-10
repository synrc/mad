-module(mad_port).
-copyright('Maxim Sokhatsky').
-compile(export_all).

replace_env(String, []) -> String;
replace_env(String, [{K,V}|Env]) ->
      replace_env(re:replace(String, io_lib:format("\\$?{?(~s)}?",[K]), V, [global, {return, list}]),Env).

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
    Env = [ {Var,Val} || {Sys,Var,Val} <- mad_utils:get_value(port_env, Config, []), system(Sys,System) ] ++
          [ {Var,Val} || {Var,Val} <- mad_utils:get_value(port_env, Config, []) ] ++
          [ {"LDFLAGS",[]},{"CFLAGS",[]}],
    [ begin
           Template = string:join(files(Dir,Files)," ") 
              ++ " CFLAGS LDFLAGS " ++ ei() ++ " -o " ++ Dir ++ "/" ++ Out,
       Args = string:strip(replace_env(Template,Env),both,32),
       % mad:info("Args: ~p~n",[Args]),
       % mad:info("Env: ~p~n",[Env]),
       {_,Status,Report} = sh:run("cc",string:tokens(Args," "),binary,Dir,Env),
       case Status of
          0 -> false;
          _ -> mad:info("Port Compilation Error:~n" ++ io_lib:format("~ts",[Report]),[]), true end
      end || {Out,Files} <- Specs ].

system(Sys,System) -> Sys == System orelse match(Sys,System).
match(Re,System)   -> case re:run(System, Re, [{capture,none}]) of match -> true; nomatch -> false end.
erts_dir()         -> lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)]).
ei_dir()           -> code:lib_dir(erl_interface).
files(Dir,Files)   -> [string:join(filelib:wildcard(Dir ++ "/" ++ F)," ")||F<-Files].
ei()               -> "-bundle -flat_namespace -undefined suppress " %% for linking phase
                      "-I"++ei_dir()++"/include "
                      "-I"++erts_dir()++"/include "
                      "-L"++ei_dir()++"/lib "
                      "-L"++erts_dir()++"/lib ".

