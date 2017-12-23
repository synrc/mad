-module(mad_cubical).
-copyright('Maxim Sokhatsky').
-compile(export_all).

compile(File,Inc,Bin,Opt,Deps) ->
    {_,_,Msg} = sh:run("cubical -b " ++ File),
    case binary:match(Msg,[<<"successfully!">>]) of
                   nomatch -> io:format("Error: ~p~n",[Msg]), true;
                   _ -> io:format("OK: ~p.~n",[filename:basename(File)]), false end.
