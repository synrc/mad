-module(mad_plan).
-copyright('Vladimir Kirillov').
-compile(export_all).

main(AppList) ->
    Relconfig = {sys, [{lib_dirs,["apps","deps"]},
                       {rel,"node","1",AppList}, {boot_rel,"node"} ]},
    {ok, Server} = reltool:start_server([{config, Relconfig}]),
    io:format("Reltool Server: ~p~n\r",[Server]),
    {ok, {release, _Node, _Erts, Apps}} = reltool_server:get_rel(Server, "node"),
    Ordered = [element(1, A) || A <- Apps] -- mad_repl:disabled(),
    io:format("Ordered: ~p~n\r",[Ordered]),
    file:write_file(".applist",io_lib:format("~w",[Ordered])),
    Ordered.
