-module(mad_leex).
-copyright('Sina Samavati').
-compile(export_all).

xrl_to_erl(F) -> filename:join(filename:dirname(F),filename:basename(F, ".xrl")) ++ ".erl".

compile(File,Inc,Bin,Opt,Deps) ->
    ErlFile = xrl_to_erl(File),
    Compiled = mad_compile:is_compiled(ErlFile,File),
    if Compiled == false ->
        leex:file(File),
        mad_erl:compile(ErlFile,Inc,Bin,Opt,Deps); true -> false end.

