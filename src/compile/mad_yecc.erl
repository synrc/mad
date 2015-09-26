-module(mad_yecc).
-copyright('Sina Samavati').
-compile(export_all).

yrl_to_erl(F) -> filename:join(filename:dirname(F),filename:basename(F, ".yrl")) ++ ".erl".

compile(File,Inc,Bin,Opt,Deps) ->
    ErlFile = yrl_to_erl(File),
    Compiled = mad_compile:is_compiled(ErlFile,File),
    if Compiled == false ->
        yecc:file(File),
        mad_erl:compile(ErlFile,Inc,Bin,Opt,Deps); true -> false end.

