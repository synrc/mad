-module(mad_bundle).
-compile(export_all).

main(App) ->
    EmuArgs = "-noshell -noinput -boot start_sasl",
    Files = files(),
    escript:create(App, [shebang, {comment, ""}, {emu_args, EmuArgs}, {archive, Files, []}]),
    ok = file:change_mode(App, 8#764).

read_file(File) -> {ok, Bin} = file:read_file(filename:absname(File)), Bin.

files() ->
    [{filename:basename(F), read_file(F)}
     || F <- filelib:wildcard(              filename:join("ebin", "*")) ++
             filelib:wildcard(filename:join(["apps", "*", "ebin", "*"])) ++
             filelib:wildcard(filename:join(["apps", "*", "priv", "templates", "*" ])) ++
             filelib:wildcard(filename:join(["deps", "*", "ebin", "*"]))].
