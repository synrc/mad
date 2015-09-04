-module(mad_static).
-copyright('Yuri Artemev').
-compile(export_all).
-define(NODE(Bin), "node_modules/.bin/"++Bin).

main(Config, ["watch"]) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> false;
        SC ->
            Port = mad_utils:get_value(assets_port, SC, 3000),
            install_deps(), serve_static(Port)
    end;
main(Config, _Params) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> false;
        SC ->
            Files = mad_utils:get_value(files, SC, []),
            install_deps(), compile_static(Files)
    end.

install_deps() ->
    case filelib:is_dir("node_modules/mincer-erl") of
        true -> false;
        _ ->
            case sh:oneliner("npm install mincer-erl") of
                {_,0,_} -> false;
                {_,_,_} -> mad:info("error while installing mincer-erl~n"), true
            end
    end.

% FIXME exit
serve_static(Port) ->
    PortStr = integer_to_list(Port),
    Res = sh:oneliner([?NODE("mincer-erl-serve"), "-p " ++ PortStr]),
    case Res of
        {_,0,_} -> false;
        {_,_,_} -> mad:info("error while serving assets~n"), true end.

compile_static(Files) ->
    Res = sh:oneliner([?NODE("mincer-erl-compile")] ++ Files),
    case Res of
        {_,0,_} -> false;
        {_,_,_} -> mad:info("error while compiling assets~n"), true end.
