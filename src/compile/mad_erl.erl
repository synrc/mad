-module(mad_erl).
-copyright('Sina Samavati').
-compile(export_all).
-define(COMPILE_OPTS(Inc, Ebin, Opts), [report, {i, Inc}, {outdir, Ebin}] ++ Opts).

erl_to_beam(Bin, F) -> filename:join(Bin, filename:basename(F, ".erl") ++ ".beam").

compile(File,Inc,Bin,Opt) ->
    BeamFile = erl_to_beam(Bin, File),
    Compiled = mad_compile:is_compiled(BeamFile, File),
    if  Compiled =:= false ->
        Opts1 = ?COMPILE_OPTS(Inc, Bin, Opt),
%        io:format("Compiling ~s Opts ~p~n\r", [File,Opts1]),
        io:format("Compiling ~s~n\r", [File]),
        compile:file(File, Opts1),
        ok;
    true -> ok end.

