-module(mad_repl).
-copyright('Maxim Sokhatsky').
-compile(export_all).

disabled() -> [].
system() -> [compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib,ssh,eldap,
             wx,ssl,runtime_tools,public_key,observer,inets,asn1,et,eunit,hipe,os_mon,parsetools,odbc].

local_app() ->
    case filename:basename(filelib:wildcard("ebin/*.app"),".app") of
         [] -> [];
         A -> list_to_atom(A) end.

applist() ->
    Name = ".applist",
    case file:read_file(Name) of
         {ok,Binary} -> parse_applist(Binary);
         {error,_} ->
           case mad_repl:load_file(Name) of
              {error,_} -> mad_resolve:main([]);
              {ok,Plan} -> parse_applist(Plan) end end.

wildcards(List) -> lists:concat([filelib:wildcard(X)||X<-List]).

parse_applist(AppList) ->
   Res = string:tokens(string:strip(string:strip(binary_to_list(AppList),right,$]),left,$[),","),
   [ list_to_atom(R) || R <-Res ]  -- disabled().

load_config() ->
   Config = wildcards(["sys.config",lists:concat(["etc/",mad:host(),"/sys.config"])]),
   _Apps = case Config of
        [] -> case mad_repl:load_file("sys.config") of
              {error,_} -> [];
              {ok,Bin} -> parse(unicode:characters_to_list(Bin)) end;
      File -> case file:consult(hd(File)) of
              {error,_} -> [];
              {ok,[A]} -> A end end.

load_config(AppConfigs,[]) ->
    [ [ application:set_env(App,K,V) || {K,V} <- Cfg] || {App,Cfg} <- AppConfigs],
    load_includes(AppConfigs).

load_includes(AppConfigs) ->
    [ begin Apps = case file:consult(File) of
                        {error,_} -> [];
                        {ok,[A]} -> A end,
             load_config(Apps, []) end || File <- AppConfigs, is_list(File) ].

acc_start(_A,Acc,Config) ->
   case is_tuple(_A) of
      true -> % If _A is app descriptor we extend the env information
          AppName = element(2, _A),
          SysConfigs = lists:flatten(lists:filtermap(
                    fun({Elem,Rest}) -> case Elem == AppName of
                        true -> { true, Rest };
                        _    -> false
                    end end, Config)),
          A = setelement(3, _A, lists:map(fun({K,V}) ->
                           case K == env of
                             true -> { K, V ++ SysConfigs };
                             _    -> { K, V }
                           end
                          end, element(3, _A)));
      false -> A = _A end,

   case application:start(A) of
         {error,{already_started,_}} -> Acc;
         {error,{_,{{M,_F,_},_Ret}}} -> [M|Acc];
         {error,{_Reason,Name}} when is_atom(_Reason) -> [Name|Acc];
         ok -> Acc;
         _  -> Acc end.

load_apps([],Config,_Acc) ->
  load_config(Config,[]),
  Res = lists:foldl(fun(A,Acc) -> case lists:member(A,system()) of
       true -> acc_start(A,Acc,Config);
          _ -> X = load_config(A),
               case X of
                    [] -> acc_start(A,Acc,Config);
                    _E -> acc_start(_E,Acc,Config) end end end,[], applist()),
  case Res of
       [] -> ok;
       _ -> mad:info("~nApps couldn't be loaded: ~p~n",[Res]) end;
load_apps(["applist"],Config,Acc) -> load_apps([],Config,Acc);
load_apps(Params,_,_Acc) -> [ application:ensure_all_started(list_to_atom(A))||A<-Params].

cwd() -> case  file:get_cwd() of {ok, Cwd} -> Cwd; _ -> "." end.

sh(Params) ->
    { _Cwd,_ConfigFileName,_Config } = mad_utils:configs(),
    SystemPath = filelib:wildcard(code:root_dir() ++ "/lib/{"
              ++ string:join([atom_to_list(X)||X<-mad_repl:system()],",") ++ "}-*/ebin"),
    UserPath   = wildcards(["{apps,deps}/*/ebin","ebin"]),
    code:set_path(SystemPath++UserPath),
    code:add_path(filename:join([cwd(),filename:basename(escript:script_name())])),
    load(),
    Config = load_config(),
    Driver = mad_utils:get_value(shell_driver,_Config,user_drv),
    repl_intro(Config),
    case os:type() of
         {win32,nt} -> os:cmd("chcp 65001"), shell:start();
                  _ -> O = whereis(user),
                       supervisor:terminate_child(kernel_sup, user),
                       Driver:start(),
                       wait(3000),
                       rewrite_leaders(O,whereis(user)) end,
    load_apps(Params,Config,[]),
    case Params of
        ["applist"] -> skip;
        _ ->  timer:sleep(infinity) end.

remove(0) -> skip;
remove(N) -> case gen_event:delete_handler(error_logger, error_logger, []) of
                  {error, module_not_found} -> ok;
                  {error_logger, _} -> remove(N-1) end.

wait(0) -> erlang:error(timeout);
wait(Timeout) -> case whereis(user) of undefined -> timer:sleep(100), wait(Timeout - 100); _ -> ok end.

rewrite_leaders(OldUser, NewUser) ->
    _ = [catch erlang:group_leader(NewUser, Pid)
         || Pid <- erlang:processes(),
            proplists:get_value(group_leader, erlang:process_info(Pid)) == OldUser,
            is_process_alive(Pid)],
    OldMasters = [Pid
         || Pid <- erlang:processes(),
            Pid < NewUser, % only change old masters
            {_,Dict} <- [erlang:process_info(Pid, dictionary)],
            {application_master,init,4} == proplists:get_value('$initial_call', Dict)],
    _ = [catch erlang:group_leader(NewUser, Pid)
         || Pid <- erlang:processes(),
            lists:member(proplists:get_value(group_leader, erlang:process_info(Pid)),
                         OldMasters)],
    try   error_logger:swap_handler(tty),
          remove(3)
    catch E:R -> hope_for_best end.

load() ->
    ets_created(),
    {ok,Sections} = escript:extract(escript:script_name(),[]),
    [Bin] = [B||{archive,B}<-Sections],
    unfold_zips(Bin).

unfold_zips(Bin) ->
    {ok,Unzip} = zip:unzip(Bin,[memory]),
    [ begin
       try
        ets:insert(filesystem,{unicode:characters_to_list(base64:decode(list_to_binary(U))),FileBin})
       catch _:_ ->
        ets:insert(filesystem,{U,FileBin})
       end,
        case U of
            "static.gz" -> unfold_zips(FileBin);
            _ -> skip end
      end || {U,FileBin} <- Unzip].

ets_created() ->
    case ets:info(filesystem) of
         undefined -> ets:new(filesystem,[set,named_table,{keypos,1},public]);
         _ -> skip end.

load_file(Name)  ->
    ets_created(),
    case ets:lookup(filesystem,Name) of
        [{Name,Bin}] -> {ok,Bin};
        _ -> {error,etsfs} end.

load_config(A) when is_atom(A) -> load_config(atom_to_list(A));
load_config(A) when is_list(A) ->
    AppFile = A ++".app",
    Name = wildcards(["{apps,deps}/*/ebin/"++AppFile,"ebin/"++AppFile]),
    case file:read_file(Name) of
         {ok,Bin} -> parse(binary_to_list(Bin));
         {error,_} -> case ets:lookup(filesystem,AppFile) of
                          [{Name,Bin}] -> parse(binary_to_list(Bin));
                          _ -> [] end end.

parse(String) ->
    {ok,Tokens,_EndLine} = erl_scan:string(String),
    {ok,AbsForm} = erl_parse:parse_exprs(Tokens),
    {value,Value,_Bs} = erl_eval:exprs(AbsForm, erl_eval:new_bindings()),
    Value.

repl_intro(Config) ->
    io:format("Configuration: ~p~n", [Config]),
    io:format("Applications:  ~p~n", [applist()]).

