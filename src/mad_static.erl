-module(mad_static).
-copyright('Yuri Artemev').
-compile(export_all).
-define(NODE(Bin), "node_modules/.bin/"++Bin).

main(Config, ["min"]) ->
    {ok,[SysConfig]} = file:consult("sys.config"),
    N2O     = proplists:get_value(n2o,SysConfig,[]),
    AppName = proplists:get_value(app,N2O,sample),
    Minify  = proplists:get_value(minify,N2O,[]),
    Command = lists:concat(["uglify -s ",string:join(element(2,Minify),","),
                                 " -o ",element(1,Minify),"/",AppName,".min.js"]),
    io:format("Minify: ~p~n",[Command]),
    case sh:run(Command) of
         {_,0,_} -> {ok,static};
         {_,_,_} -> mad:info("minifyjs not installed. try `npm install -g uglify`~n"), {error,minifier}
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
                {_,_,_} -> mad:info("error while installing mincer-erl~n"), {error,install}
            end
    end.

% FIXME exit
serve_static(Port) ->
    PortStr = integer_to_list(Port),
    Res = sh:oneliner([?NODE("mincer-erl-serve"), "-p " ++ PortStr]),
    case Res of
        {_,0,_} -> {ok,static};
        {_,_,_} -> mad:info("error while serving assets~n"), {error,assests} end.

compile_static(Files) ->
    Res = sh:oneliner([?NODE("mincer-erl-compile")] ++ Files),
    case Res of
        {_,0,_} -> {ok,static};
        {_,_,_} -> mad:info("error while compiling assets~n"), {error,compile} end.

app([]) -> app(["sample"]);
app(Params) ->
    [Name] = Params,
    mad_repl:load(),
    Apps = ets:tab2list(filesystem),
    [ case string:str(File,"priv/web") of
       1 -> Relative = unicode:characters_to_list(Name ++ string:replace(string:substr(File, 9), "sample", Name, all), utf8),
            mad:info("Create File: ~p~n",[Relative]),
            filelib:ensure_dir(Relative),
            BinNew = string:replace(Bin, "sample", Name, all),
            file:write_file(Relative, BinNew);
       _ -> skip
       end || {File,Bin} <- Apps, is_list(File) ], {ok,Name}.
