-module(mad_plan).
-compile(export_all).

disabled() -> [wx,webtool,ssl,runtime_tools,public_key,observer,inets,asn1,et,eunit,hipe].

applist() -> 
    case file:read_file(".applist") of
         {ok,Binary} -> parse_applist(binary_to_list(Binary)); 
         {error,Reason} -> main([ list_to_atom(filename:basename(App))
                || App <- filelib:wildcard("{apps,deps}/*/")] -- disabled()) end.

parse_applist(AppList) -> 
   Res = string:tokens(string:strip(string:strip(AppList,right,$]),left,$[),","),
   [ list_to_atom(R) || R <-Res ]  -- disabled().

relconfig(Apps) -> {sys, [{lib_dirs,["apps","deps"]}, {rel,"node","1",Apps}, {boot_rel,"node"} ]}.

main(AppList) ->
    Relconfig = relconfig(AppList),
    {ok, Server} = reltool:start_server([{config, Relconfig}]),
    {ok, {release, _Node, _Erts, Apps}} = reltool_server:get_rel(Server, "node"),
    Ordered = [element(1, A) || A <- Apps] -- disabled(),
    io:format("Ordered: ~p~n",[Ordered]),
    io:format("Applist Generation: ~w~n", [file:write_file(".applist",io_lib:format("~w",[Ordered]))]),
    Ordered.
