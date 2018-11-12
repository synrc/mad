-module(mad_static).
-copyright('Yuri Artemev').
-compile(export_all).
-define(NODE(Bin), "node_modules/.bin/"++Bin).

main(_Config, ["min"]) ->
    SysConfig = try {ok,[S]} = file:consult("sys.config"), S catch _:_ -> [] end,
    N2O     = proplists:get_value(n2o,SysConfig,[]),
    AppName = proplists:get_value(app,N2O,sample),
    Minify  = proplists:get_value(minify,N2O,{[],[]}),
    Command = lists:concat(["uglify -s ",string:join(element(2,Minify),","),
                                 " -o ",element(1,Minify),"/",AppName,".min.js"]),
    case sh:run(Command) of
         {_,0,_} -> {ok,static};
         {_,_,_} -> mad:info("minifyjs not installed. try `npm install -g uglify`~n"), {error,"Minifier."}
    end;

main(Config, ["watch"]) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> {ok,static};
        SC ->
            Port = mad_utils:get_value(assets_port, SC, 3000),
            install_deps(), serve_static(Port)
    end;
main(Config, _Params) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> {ok,static};
        SC ->
            Files = mad_utils:get_value(files, SC, []),
            install_deps(), compile_static(Files)
    end.

install_deps() ->
    case filelib:is_dir("node_modules/mincer-erl") of
        true -> {ok,static};
        _ ->
            case sh:oneliner("npm install mincer-erl") of
                {_,0,_} -> {ok,static};
                {_,_,_} -> mad:info("error while installing mincer-erl~n"), {error,"Static install."}
            end
    end.

% FIXME exit
serve_static(Port) ->
    PortStr = integer_to_list(Port),
    Res = sh:oneliner([?NODE("mincer-erl-serve"), "-p " ++ PortStr]),
    case Res of
        {_,0,_} -> {ok,static};
        {_,_,_} -> mad:info("error while serving assets~n"), {error,"Static assests."} end.

compile_static(Files) ->
    Res = sh:oneliner([?NODE("mincer-erl-compile")] ++ Files),
    case Res of
        {_,0,_} -> {ok,static};
        {_,_,_} -> mad:info("error while compiling assets~n"), {error,"Static compile."} end.

app([]) -> app(["web","sample"]);
app([Name]) -> app(["web",Name]);
app([Skeleton,Name|_]) ->
    io:format("Scaffolding ~p Name ~p~n",[Skeleton,Name]),
    mad_repl:load(),
    Apps = ets:tab2list(filesystem),
    try
    [ begin %io:format("File: ~p~n",[{File,Name,string:replace(File, "sample", Name, all)}]),
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
