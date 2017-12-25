-module(mad_cubical).
-copyright('Maxim Sokhatsky').
-compile(export_all).

compile(File,Inc,Bin,Opt,Deps) ->
    {X,Res,Msg} = sh:run("cubical -b " ++ File),
    case Res of
         1 -> true;
         0 -> case binary:match(Msg,[<<"successfully!">>]) of
                   nomatch -> io:format("Error: ~p~n",[Msg]), true;
                   _ -> io:format("OK: ~p.~n",[filename:basename(File)]), false end end.
