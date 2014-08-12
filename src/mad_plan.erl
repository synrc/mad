-module(mad_plan).
-compile(export_all).

applist() -> 
    case file:read_file(".applist") of
         {ok,Binary} -> parse_applist(binary_to_list(Binary)++"."); 
         {error,Reason} -> main([ list_to_atom(filename:basename(App))
                             || App <- filelib:wildcard("{apps,deps}/*")  ] -- ['rebar.config']) end.

parse_applist(AppList) ->
    {ok,Tokens,_EndLine} = erl_scan:string(AppList),
    {ok,AbsForm} = erl_parse:parse_exprs(Tokens),
    {value,Value,_Bs} = erl_eval:exprs(AbsForm, erl_eval:new_bindings()),
    Value.

relconfig(Apps) ->
    LibDirs = [Dir || Dir <- ["apps", "deps"], case file:read_file_info(Dir) of {ok, _} -> true; _ -> false end],
    {sys, [{lib_dirs,LibDirs}, {rel,"node","1",Apps}, {profile, embedded},
           {boot_rel,"node"}%, {app,observer,[{incl_cond,exclude}]}
             ]}.

main(AppList) ->
    Relconfig = relconfig(AppList),
    io:format("Relconfig: ~p",[Relconfig]),
    {ok, Server} = reltool:start_server([{config, Relconfig}]),
    {ok, {release, _Node, _Erts, Apps}} = reltool_server:get_rel(Server, "node"),
    Ordered = [element(1, A) || A <- Apps],
    io:format("Applist Generation: ~w~n", [file:write_file(".applist",io_lib:format("~w",[Ordered]))]),
    Ordered.
