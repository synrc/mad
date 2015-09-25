-module(mad_templates).
-copyright('Maxim Sokhatsky').
-compile(export_all).

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
       end || {File,Bin} <-Apps], false.

lib(_) -> false.
