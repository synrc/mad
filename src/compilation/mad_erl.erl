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
ret({error,Errors,_}) ->
    S=case file:get_cwd() of {ok,Cwd} -> length(Cwd); _ -> 0 end,
    [[ mad:info("Line ~p: ~p in ~p~n",[ L,R,lists:nthtail(S,F) ]) || {L,_,R} <- E ] || {F,E} <- Errors ], true;
ret({ok,_}) -> false;
ret({ok,_,_}) -> false;
ret({ok,_,_,_}) -> false.
