-module(mad_static).
-compile(export_all).

main(_Config, ["min"]) ->
    SysConfig = try {ok,[S]} = file:consult("sys.config"), S catch _:_ -> [] end,
    N2O     = proplists:get_value(n2o,SysConfig,[]),
    AppName = proplists:get_value(app,N2O,sample),
    Minify  = proplists:get_value(minify,N2O,{[],[]}),
    Command = lists:concat(["uglify -s ",string:join(element(2,Minify),","),
                                 " -o ",element(1,Minify),"/",AppName,".min.js"]),
    case sh:run(Command) of
         {_,0,_} -> {ok,static};
         {_,_,_} -> mad:info("minifyjs not installed. try `npm install -g uglify`~n"),
                    {error,"Minifier."}
    end.

app([]) -> app(["web","sample"]);
app([Name]) -> app(["web",Name]);
app([Skeleton,Name|_]) ->
    io:format("Scaffolding ~p Name ~p~n",[Skeleton,Name]),
    mad_repl:load(),
    Apps = ets:tab2list(filesystem),
    try
    [ begin
       case string:str(File,"priv/"++Skeleton) of
       1 -> Relative = unicode:characters_to_list(Name++
                       string:replace(
                       string:replace(File, "sample", Name, all),
                                     "priv/"++Skeleton, "", all), utf8),
            mad:info("Created: ~p~n",[Relative]),
            filelib:ensure_dir(Relative),
            BinNew = string:replace(Bin, "sample", Name, all),
            file:write_file(Relative, BinNew);
       _ -> skip
       end end || {File,Bin} <- Apps, is_list(File)],
       {ok,Name}
    catch _:_ -> {error,"Skeleton failed."} end.
