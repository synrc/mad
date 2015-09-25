-module(vox_create).
-compile(export_all).

command(Args) ->
    lists:foldl(fun create/2,[],Args),
    {ok,?MODULE}.

create(App,Acc) ->
    Name = filename:basename(App,".tgz"),
    vox:info("Unpack Container: ~p~n",[Name]),
    {ok,Bin} = file:read_file(App),
    erl_tar:extract({binary,zlib:gunzip(Bin)},[{cwd,lists:concat(["apps/",Name])}]).
