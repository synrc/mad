-module(mad_erl).
-copyright('Sina Samavati').
-compile(export_all).
-define(COMPILE_OPTS(Inc, Ebin, Opts, Deps), [report, {i, [Inc]}, {outdir, Ebin}] ++ Opts++Deps).

erl_to_beam(Bin, F) -> filename:join(Bin, filename:basename(F, ".erl") ++ ".beam").

compile(File,Inc,Bin,Opt,Deps) ->
    BeamFile = erl_to_beam(Bin, File),
    Compiled = mad_compile:is_compiled(BeamFile, File),
    if  Compiled =:= false ->
        Opts1 = ?COMPILE_OPTS(Inc, Bin, Opt, Deps),
%        io:format("Compiling ~s~n Opts ~p~n Deps~p~n", [File,Opts1,Deps]),
        io:format("Compiling ~s~n", [File]),
        ret(compile:file(File, Opts1));
    true -> false end.

ret(error) -> true;
ret({error,_,_}) -> true;
ret({ok,_}) -> false;
ret({ok,_,_}) -> false;
ret({ok,_,_,_}) -> false.
