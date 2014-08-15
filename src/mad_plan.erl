-module(mad_plan).
-compile(export_all).

relconfig(Apps) ->
    {sys, [{lib_dirs,[ filename:absname(LibDir) || LibDir <- ["apps","deps","."], filelib:is_dir(LibDir) ]},
           {rel,"node","1",Apps}, {boot_rel,"node"} ]}.

main(AppList) ->
    Relconfig = relconfig(AppList),
    {ok, Server} = reltool:start_server([{config, Relconfig}]),
    io:format("Reltool Server: ~p~n\r",[Server]),
    {ok, {release, _Node, _Erts, Apps}} = reltool_server:get_rel(Server, "node"),
    Ordered = [element(1, A) || A <- Apps] -- mad_repl:disabled(),
    io:format("Ordered: ~p~n\r",[Ordered]),
    io:format("Applist Generation: ~w~n\r", [file:write_file(".applist",io_lib:format("~w",[Ordered]))]),
    Ordered.

