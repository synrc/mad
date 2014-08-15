-module(mad_bundle).
-compile(export_all).

main(App) ->
    EmuArgs = "-noshell -noinput",
    Files = static() ++ beams(),
    escript:create(App,[shebang,{comment,""},{emu_args,EmuArgs},{archive,Files,[memory]}]),
    file:change_mode(App, 8#764).

read_file(File) -> {ok, Bin} = file:read_file(filename:absname(File)), Bin.

static() -> Name = "static.gz",
    {ok,{File,Bin}} = zip:create(Name,
        [F || F <- filelib:wildcard("{apps,deps}/*/priv/**"), not filelib:is_dir(F) ],
        [{compress,all},memory]), [ { Name, Bin } ].

beams() ->
    [ { filename:basename(F), read_file(F) } || F <-
        lists:concat([filelib:wildcard(X)||X <- 
        [ "ebin/*","deps/*/ebin/*","apps/*/ebin/*",
          "rels/*/files/sys.config","sys.config",".applist"]])].
