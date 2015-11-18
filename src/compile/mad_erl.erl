-module(mad_erl).
-copyright('Sina Samavati').
-compile(export_all).
-define(COMPILE_OPTS(Inc, Ebin, Opts, Deps), [return_errors, return_warnings, {i, [Inc]}, {outdir, Ebin}] ++ Opts++Deps).

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
ret({error,X}) -> lines(error,X);
ret({error,X,_}) -> lines(error,X);
ret({ok,_}) -> false;
ret({ok,_,[]}) -> false;
ret({ok,_,X}) -> lines(warning,X), false;
ret({ok,_,X,_}) -> lines(warning,X), false.

lines(Tag,X) ->
    S=case file:get_cwd() of {ok,Cwd} -> length(Cwd); _ -> 0 end,
    [[ mad:info("Line ~p: ~p ~p in ~p~n",[ L,Tag,R,lists:nthtail(S,F) ]) || {L,_,R} <- E ] || {F,E} <- X ], true.
