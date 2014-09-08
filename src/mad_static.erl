-module(mad_static).
-copyright('Yuri Artemev').
-compile(export_all).
-define(NODE(Bin), "node_modules/.bin/"++Bin).

main(Config, ["watch"]) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> skip;
        SC ->
            Port = mad_utils:get_value(assets_port, SC, 3000),
            install_deps(), serve_static(Port)
    end;
main(Config, _Params) ->
    case mad_utils:get_value(static, Config, []) of
        [] -> skip;
        SC ->
            Files = mad_utils:get_value(files, SC, []),
            install_deps(), compile_static(Files)
    end.

install_deps() ->
    case filelib:is_dir("node_modules/mincer-erl") of
        true -> ok;
        _ ->
            case sh:oneliner("npm install mincer-erl") of
                {_,0,_} -> ok;
                {_,_,_} -> exit("error while installing mincer-erl")
            end
    end.

% FIXME exit
serve_static(Port) ->
    PortStr = integer_to_list(Port),
    sh:oneliner([?NODE("mincer-erl-serve"), "-p " ++ PortStr]).

compile_static(Files) ->
    Res = sh:oneliner([?NODE("mincer-erl-compile")] ++ Files),
    case Res of
        {_,0,_} -> ok;
        {_,_,_} -> exit("error while compiling assets")
    end.
