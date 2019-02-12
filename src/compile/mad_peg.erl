-module(mad_peg).
-compile(export_all).

peg_to_erl(F) ->
    filename:join(filename:dirname(F),filename:basename(F, ".peg")) ++ ".erl".

compile(File,Inc,Bin,Opt,Deps) ->
    ErlFile = peg_to_erl(File),
    Compiled = mad_compile:is_compiled(ErlFile,File),
    if Compiled == false ->
        neotoma:file(File),
        mad_erl:compile(ErlFile,Inc,Bin,Opt,Deps);
      true -> false end.
