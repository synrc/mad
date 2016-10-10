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
        Files = files(Dir,Patern),
        Ouput = Dir ++ "/" ++ Out,
        case is_compiled(Ouput,Files) of 
          false -> Template = string:join(Files," ") 
                              ++ " CFLAGS LDFLAGS " ++ ei(Flavour,Out) ++ " -o " ++ Ouput,
                   Args = string:strip(replace_env(Template,Env),both,32),
                   mad:info("Args: ~p~n",[Args]),
                   mad:info("Env: ~p~n",[Env]),
                   {_,Status,Report} = sh:run("cc",string:tokens(Args," "),binary,Dir,Env),
                   case Status of
                    0 -> false;
                    _ -> mad:info("Port Compilation Error:~n" ++ io_lib:format("~ts",[Report]),[]), true 
                   end;
          _ -> mad:info("No Need recompile  ~p~n",[{Ouput,Files}]), 
               false
        end
      end || {Out,Patern} <- Specs ].

is_compiled(O,Files) -> lists:foldl(fun(X,false) -> false;
                                       (X, true) -> mad_utils:last_modified(O) >= mad_utils:last_modified(X)
                                    end, true, Files).
system(Sys,System) -> Sys == System orelse match(Sys,System).
match(Re,System)   -> case re:run(System, Re, [{capture,none}]) of match -> true; nomatch -> false end.
erts_dir()         -> lists:concat([code:root_dir(), "/erts-", erlang:system_info(version)]).
ei_dir(inc)        -> case code:lib_dir(erl_interface) of {error,bad_name} -> ""; 
                           D -> "-I"++filename:join(D, "include") end;
ei_dir(lib)        -> case code:lib_dir(erl_interface) of {error,bad_name} -> ""; 
                           D -> "-L"++filename:join(D, "lib") end.
files(Dir,Files)   -> [string:join(filelib:wildcard(Dir ++ "/" ++ F)," ")||F<-Files].
ei(Flavour,Out)    -> type(Flavour,Out)  
                      ++ ei_dir(inc) ++
                      " -I"++filename:join(erts_dir(), "include")++ " "
                       ++ ei_dir(lib) ++ 
                      " -L"++filename:join(erts_dir(), "lib").
type(Flavour,Out)  -> case {Flavour, filename:extension(Out)} of  %% exe or shared
                        {_,         []} -> "";
                        {darwin, ".so"} -> "-bundle -flat_namespace -undefined suppress "
                      end.
                       
