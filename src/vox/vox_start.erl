-module(vox_start).
-compile(export_all).

command(Args) -> {ok,lists:map(fun start/1,Args)}.

start(App) ->
    vox:info("App: ~p~n",[App]),
    {ok,Bin}  = file:read_file(lists:concat(["apps/",App,"/config.json"])),
    {Json   } = jsone:decode(Bin),
    {Process} = proplists:get_value(<<"process">>,Json),
    Args      = proplists:get_value(<<"args">>,Process),
    Concat    = string:join(lists:map(fun(X) -> binary_to_list(X) end,Args)," "),
    {_,R,S}   = sh:run(Concat,<<"log">>,lists:concat(["apps/",App])),
    vox:info("Oneliner: ~p~n",[Concat]),
    {ret(R),S}.

ret(0) -> ok;
ret(_) -> error.
