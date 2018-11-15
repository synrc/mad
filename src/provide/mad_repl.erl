-module(mad_repl).
-copyright('Maxim Sokhatsky').
-compile(export_all).

disabled() -> [].
system() -> [compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib,ssh,eldap,common_test,eunit,
             wx,ssl,runtime_tools,public_key,observer,inets,asn1,et,eunit,hipe,os_mon,parsetools,odbc,snmp].

escript_name() ->
    try escript:script_name() of N -> N catch _:_ -> [] end.

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
              {error,_} -> mad_release:resolve([]);
              {ok,Plan} -> parse_applist(Plan) end end.

wildcards(List) -> lists:concat([filelib:wildcard(X)||X<-List]).

parse_applist(AppList) ->
    Res = string:tokens(string:strip(string:strip(binary_to_list(AppList),right,$]),left,$[),","),
    [ list_to_atom(R) || R <-Res ]  -- disabled().

load_sysconfig() ->
    Config = wildcards(["sys.config",lists:concat(["etc/",mad:host(),"/sys.config"])]),
    _Apps = case Config of
        [] -> case mad_repl:load_file("sys.config") of
              {error,_} -> [];
              {ok,Bin} -> parse(unicode:characters_to_list(Bin)) end;
      File -> case file:consult(hd(File)) of
              {error,_} -> [];
              {ok,[A]} -> merge_include(A, []) end end.

application_config(AppConfigs) ->
    [[application:set_env(App,K,V) || {K,V} <- Cfg] || {App,Cfg} <- AppConfigs].

merge_include([], Acc) -> Acc;
merge_include([H | Rest], Acc) -> merge_include(Rest, merge_config(H, Acc)).

merge_config({App, NewConfig} = Add, Acc) ->
    lists:keystore(App, 1, Acc, case lists:keyfind(App, 1, Acc) of
        false ->  Add;
        {App, AppConfigs} -> merge_config(App, AppConfigs, NewConfig)
    end);

merge_config(File, Acc) when is_list(File) ->
    BFName = filename:basename(File, ".config"),
    FName = filename:join(filename:dirname(File), BFName ++ ".config"),
    case file:consult(FName) of
        {ok,[A]} -> merge_include(A, Acc);
        _ -> Acc
    end.

merge_config(App, AppConfigs, []) -> {App, AppConfigs};
merge_config(App, AppConfigs, [{Key, _} = Tuple | Rest]) ->
    merge_config(App, lists:keystore(Key, 1, AppConfigs, Tuple), Rest).

acc_start(A,Acc) ->
    application:ensure_all_started(A), Acc.

% for system application we just start, forgot about env merging

load(true,A,Acc,_Config) ->
    acc_start(A,Acc);

% for user application we should merge app from ebin and from sys.config
% and start application using tuple argument in app controller

load(X,A,Acc,Config) ->
    try {application,Name,Map} = load_config(A),
        NewEnv = merge(Config,Map,Name),
        acc_start({application,Name,set_value(env,1,Map,{env,NewEnv})},Acc)
    catch _:_ -> io:format("Application Load Error: ~p",[{X,A,Acc}]) end.

merge(Config,Map,Name) ->
    lists:foldl(fun({Name2,E},Acc2) when Name2 =:= Name ->
    lists:foldl(fun({K,V},Acc1)      -> set_value(K,1,Acc1,{K,V}) end,Acc2,E);
                          (_,Acc2)   -> Acc2 end, proplists:get_value(env,Map,[]), Config).

load_apps([],Config,Acc)             -> [ load(lists:member(A,system()),A,Acc,Config) || A <- applist()];
load_apps(["applist"],Config,Acc)    -> load_apps([],Config,Acc);
load_apps(Params,_,_Acc)             -> [ application:ensure_all_started(list_to_atom(A))||A<-Params].

set_value(Name,Pos,List,New)         -> add_replace(lists:keyfind(Name,Pos,List),Name,Pos,List,New).
add_replace(false,_N,_P,List,New)    -> [New|List];
add_replace(_____,Name,Pos,List,New) -> lists:keyreplace(Name,Pos,List,New).

cwd() -> case  file:get_cwd() of {ok, Cwd} -> Cwd; _ -> "." end.

sh(Params) ->
    { _Cwd,_ConfigFileName,_Config } = mad_utils:configs(),
    SystemPath = filelib:wildcard(code:root_dir() ++ "/lib/{"
              ++ string:join([atom_to_list(X)||X<-mad_repl:system()],",") ++ "}-*/ebin"),
    UserPath   = wildcards(["{apps,deps}/*/ebin","ebin"]),
    code:set_path(SystemPath++UserPath),

    case escript_name() of
        [] -> ok; % VSCode
         N -> code:add_path(filename:join([cwd(),filename:basename(N)])),
              load()
    end,

    Config = load_sysconfig(),
    application_config(Config),
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
    catch _E:_R -> hope_for_best end.

load() ->
    ets_created(),
    {ok,Sections} = escript:extract(escript:script_name(),[]),
    [Bin] = [B||{archive,B}<-Sections],
    unfold_zips(Bin).

unfold_zips(Bin) ->
    {ok,Unzip} = zip:unzip(Bin,[memory]),
    [ begin
       try
          Path = binary_to_list(base64:decode(list_to_binary(U))),
          ets:insert(filesystem,{unicode:characters_to_list(Path),FileBin}),
          case Path of
             "deps/n2o/priv/" ++ _X ->
                           filelib:ensure_dir(filename:dirname(Path)++"/"),
                           file:write_file(Path,FileBin);
             "priv/static/" ++ _X ->
                           filelib:ensure_dir(filename:dirname(Path)++"/"),
                           file:write_file(Path,FileBin);
             _ -> ok
         end
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
                          [{AppFile,Bin}] -> parse(binary_to_list(Bin));
                          _ -> [] end end.

parse(String) ->
    {ok,Tokens,_EndLine} = erl_scan:string(String),
    {ok,AbsForm} = erl_parse:parse_exprs(Tokens),
    {value,Value,_Bs} = erl_eval:exprs(AbsForm, erl_eval:new_bindings()),
    Value.

repl_intro(Config) ->
    io:format("Configuration: ~p~n", [Config]),
    io:format("Applications:  ~p~n", [applist()]).

