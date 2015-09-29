-module(mad_repl).
-copyright('Maxim Sokhatsky').
-compile(export_all).

disabled() -> [].
system() -> [compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib,ssh,eldap,
             wx,webtool,ssl,runtime_tools,public_key,observer,inets,asn1,et,eunit,hipe,os_mon].

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
   Config = wildcards(["sys.config"]),
   Apps = case Config of
        [] -> case mad_repl:load_file("sys.config") of
              {error,_} -> [];
              {ok,Bin} -> parse(binary_to_list(Bin)) end;
      File -> case file:consult(File) of
              {error,_} -> [];
              {ok,[A]} -> A end end,
 [ begin [ application:set_env(App,K,V) || {K,V} <- Cfg ], {App,Cfg} end || {App,Cfg} <- Apps ].

acc_start(A,Acc) ->
   case application:start(A) of
         {error,{already_started,_}} -> Acc;
         {error,{_,{{M,_F,_},_Ret}}} -> [M|Acc];
         {error,{_Reason,Name}} when is_atom(_Reason) -> [Name|Acc];
         ok -> Acc;
         _  -> Acc end.

load_apps([],_,_Acc) ->
  Res = lists:foldl(fun(A,Acc) -> case lists:member(A,system()) of
       true -> acc_start(A,Acc);
          _ -> case load_config(A) of
                    [] -> acc_start(A,Acc);
                    _E -> acc_start(_E,Acc) end end end,[], applist()),
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
    pre(Driver),
    case os:type() of
         {win32,nt} -> shell:start();
                  _ -> Driver:start() end,
    post(Driver),
    load_apps(Params,Config,[]),
    case Params of
        ["applist"] -> skip;
        _ ->  timer:sleep(infinity) end.

load() ->
    ets_created(),
    {ok,Sections} = escript:extract(escript:script_name(),[]),
    [Bin] = [B||{archive,B}<-Sections],
    unfold_zips(Bin).

unfold_zips(Bin) ->
    {ok,Unzip} = zip:unzip(Bin,[memory]),
    [ begin
        ets:insert(filesystem,{U,FileBin}),
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

% we need to call printing before starting driver for user_drv
% but for start_kjell we should call after, that's why we have pre and post here.

pre(start_kjell) -> [];
pre(user_drv) -> unregister(user), appconfig(user_drv);
pre(Driver) -> appconfig(Driver).
post(start_kjell) -> appconfig(start_kjell);
post(_) -> [].
print(Label,Value,start_kjell) -> io:requests([{put_chars,Label ++ normalize(length(Label)+1,Value) ++ "\n\r"}]);
print(Label,Value,_) -> mad:info("~s~p~n",[Label,Value]).
normalize(Padding,V) -> [ case X of 10 -> [13,10]; E -> E end || X <- lists:flatten(pp(Padding,V) )].
pp(Padding,V) -> k_io_lib_pretty:print(V, Padding, 80, 30, 60, fun(_,_)-> no end).
appconfig(Driver) ->
    print("Configuration: ", load_config(), Driver),
    print("Applications: ",  applist(),     Driver).
