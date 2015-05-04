-module(mad_bundle).
-copyright('Maxim Sokhatsky').
-compile(export_all).

id(X) -> X.

main(App) ->
    EmuArgs = "-noshell -noinput",
    Files = static() ++ beams(fun filename:basename/1),
    escript:create(App,[shebang,{comment,""},{emu_args,EmuArgs},{archive,Files,[memory]}]),
    file:change_mode(App, 8#764),
    false.

read_file(File) -> {ok, Bin} = file:read_file(filename:absname(File)), Bin.

static() -> Name = "static.gz",
    {ok,{_,Bin}} = zip:create(Name,
        [ F || F <- mad_repl:wildcards(["{apps,deps}/*/priv/**","priv/**"]), not filelib:is_dir(F) ],
        [{compress,all},memory]), [ { Name, Bin } ].

beams() -> beams(fun id/1).
beams(Fun) ->
    [ { Fun(F), read_file(F) } || F <-
        lists:concat([filelib:wildcard(X)||X <-
        [ "ebin/*","{apps,deps}/*/ebin/*","sys.config",".applist"]])].

privs() -> privs(fun id/1).
privs(Fun) ->
    [ { Fun(F), read_file(F) } || F <-
        lists:concat([filelib:wildcard(X)||X <-
        [ F || F <- mad_repl:wildcards(["{apps,deps}/*/priv/**","priv/**"]), not filelib:is_dir(F) ]])].
