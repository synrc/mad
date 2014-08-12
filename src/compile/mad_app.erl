-module(mad_app).
-compile(export_all).

app_src_to_app(Filename) -> filename:basename(Filename, ".app.src") ++ ".app".

validate_property({modules, _}, Modules) -> {modules, Modules};
validate_property(Else, _) -> Else.

compile(File,_Inc,Bin,_Opt) ->
    AppFile = filename:join(Bin, app_src_to_app(File)),
    Compiled = mad_compile:is_compiled(AppFile, File),
    if  Compiled =:= false ->
    io:format("Writing ~s~n\r", [AppFile]),
    BeamFiles = filelib:wildcard("*.beam", Bin),
    Modules = [list_to_atom(filename:basename(X, ".beam")) || X <- BeamFiles],
    [Struct|_] = mad_utils:consult(File),
    {application, AppName, Props} = Struct,
    Props1 = add_modules_property(Props),
    Props2 = [validate_property(X, Modules) || X <- Props1],
    Struct1 = {application, AppName, Props2},
    file:write_file(AppFile, io_lib:format("~p.~n", [Struct1])),
    ok;
    true -> ok end.

add_modules_property(Properties) ->
    case lists:keyfind(modules, 1, Properties) of
        {modules, _} -> Properties;
        _ -> Properties ++ [{modules, []}] end.
