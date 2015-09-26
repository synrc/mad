-module(mad_static).
-copyright('Yuri Artemev').
-compile(export_all).
-define(NODE(Bin), "node_modules/.bin/"++Bin).

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
       1 -> Relative = Name ++ string:substr(File, 9),
            mad:info("Create File: ~p~n",[Relative]),
            filelib:ensure_dir(Relative),
            file:write_file(Relative,Bin);
       _ -> skip
       end || {File,Bin} <- Apps ], {ok,Name}.
