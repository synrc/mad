-module(mad_repl).
-copyright('Maxim Sokhatsky').
-compile(export_all).

disabled() -> [wx,webtool,ssl,runtime_tools,public_key,observer,inets,asn1,et,eunit,hipe].
system() -> [compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,stdlib].

local_app() -> 
    case filename:basename(filelib:wildcard("ebin/*.app"),".app") of
         [] -> [];
         A -> [list_to_atom(A)] end.

applist() -> 
    Name = ".applist",
    case file:read_file(Name) of
         {ok,Binary} -> parse_applist(Binary); 
         {error,Reason} ->
           case mad_repl:load_file(Name) of
              <<>> -> mad_plan:main([ list_to_atom(filename:basename(App))
                || App <- wildcards(["{apps,deps}/*"]), filelib:is_dir(App) ]);
              Plan -> parse_applist(Plan) end end.

wildcards(List) -> lists:concat([filelib:wildcard(X)||X<-List]).

parse_applist(AppList) -> 
   Res = string:tokens(string:strip(string:strip(binary_to_list(AppList),right,$]),left,$[),","),
   [ list_to_atom(R) || R <-Res ]  -- disabled().

load_config() ->
   Config = wildcards(["rels/*/files/sys.config","sys.config"]),
   Apps = case Config of
      [] -> case mad_repl:load_file("sys.config") of
            <<>> -> [];
            Bin -> parse(binary_to_list(Bin)) end;
      File ->
            case file:consult(File) of
            {error,_} -> [];
            {ok,[A]} -> A end
    end,
    io:format("Configuration: ~p\n\r",[Apps]),
    [ begin 
%        io:format("\t~p: ~p\n\r",[App,Cfg]),
        [ application:set_env(App,K,V) || {K,V} <- Cfg ],
        {App,Cfg}
    end || {App,Cfg} <- Apps ].

load_apps([],Config) -> [ begin
    case lists:member(A,system()) of
         true -> application:start(A);
            _ ->
                 Cfg = load_config(A),
                 case Cfg of [] -> application:start(A);
                              E -> 
%                 io:format("User Application Start: ~p~n\r",[A]),
                              application:start(E) end end

    end || A <- applist()];
load_apps(["applist"],Config) -> load_apps([],Config);
load_apps(Params,Config) -> [ application:ensure_all_started(list_to_atom(A))||A<-Params].

cwd() -> {ok, Cwd} = file:get_cwd(), Cwd.

main(Params) -> 
    SystemPath = filelib:wildcard(code:root_dir() ++ 
      "/lib/{"++ string:join([atom_to_list(X)||X<-mad_repl:system()],",") ++ "}-*/ebin"),
    UserPath = wildcards(["{apps,deps}/*/ebin","ebin"]),
    code:set_path(SystemPath++UserPath),
    code:add_path(filename:join([cwd(),filename:basename(escript:script_name())])),
    load(),
    io:format("Applications: ~p\n\r",[applist()]),
    Config = load_config(),

    case os:type() of
         {win32,nt} -> shell:start();
                  _ -> user_drv:start() end,

    load_apps(Params,Config),
    case Params of
        ["applist"] -> skip;
        _ ->  timer:sleep(infinity) end.

load() ->

    case ets:info(filesystem) of
         undefined -> ets:new(filesystem,[set,named_table,{keypos,1},public]);
         _ -> skip end,

    {ok,Sections} = escript:extract(escript:script_name(),[]),
    [Bin] = [B||{archive,B}<-Sections],
    unfold_zips(Bin).

unfold_zips(Bin) ->
    {ok,Unzip} = zip:unzip(Bin,[memory]),
    [ begin
        io:format("Unzip: ~p~n\r",[U]),
        ets:insert(filesystem,{U,FileBin}),
        case U of
            "static.gz" -> unfold_zips(FileBin);
            _ -> skip end
      end || {U,FileBin} <- Unzip].

load_file(Name)  ->
    case ets:lookup(filesystem,Name) of
        [{Name,Bin}] -> Bin;
        _ -> <<>> end.

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
