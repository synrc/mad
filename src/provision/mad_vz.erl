-module(mad_vz).
-compile(export_all).

create(App,_) -> create(App).
create(App) ->
    Name = filename:basename(App,".tgz"),
    mad:info("Unpack Container: ~p~n",[Name]),
    {ok,Bin} = file:read_file(App),
    erl_tar:extract({binary,zlib:gunzip(Bin)},[{cwd,lists:concat(["apps/",Name])}]).

start(App) ->
    mad:info("App: ~p~n",[App]),
    {ok,Bin}  = file:read_file(lists:concat(["apps/",App,"/config.json"])),
    {Json   } = jsone:decode(Bin),
    {Process} = proplists:get_value(<<"process">>,Json),
    Args      = proplists:get_value(<<"args">>,Process),
    Concat    = string:join(lists:map(fun(X) -> binary_to_list(X) end,Args)," "),
    {_,R,S}   = sh:run(Concat,<<"log">>,lists:concat(["apps/",App])),
    mad:info("Oneliner: ~p~n",[Concat]),
    {ret(R),S}.

stop(App) -> ok.

ret(0) -> ok;
ret(_) -> error.
