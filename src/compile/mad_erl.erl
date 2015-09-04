-module(mad_erl).
-copyright('Sina Samavati').
-compile(export_all).
-define(COMPILE_OPTS(Inc, Ebin, Opts, Deps), [return_errors, {i, [Inc]}, {outdir, Ebin}] ++ Opts++Deps).

erl_to_beam(Bin, F) -> filename:join(Bin, filename:basename(F, ".erl") ++ ".beam").

compile(File,Inc,Bin,Opt,Deps) ->
    BeamFile = erl_to_beam(Bin, File),
    Compiled = mad_compile:is_compiled(BeamFile, File),
    if  Compiled =:= false ->
        Opts1 = ?COMPILE_OPTS(Inc, Bin, Opt, Deps),
        mad:info("Compiling ~s~n", [File -- mad_utils:cwd()]),
        ret(compile:file(File, Opts1));
    true -> false end.

ret(error) -> true;
ret({error,Errors,Warnings}) ->
    [ [ mad:info("Line ~p: ~p~n",[Line,R]) || {Line,_,R} <- Reports]
      || {File,Reports} <- Errors ], true;
ret({ok,X}) -> false;
ret({ok,X,Y}) -> false;
ret({ok,X,Y,Z}) -> false.
