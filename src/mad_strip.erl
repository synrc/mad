-module(mad_strip).
-export([main/1]).

main(_) ->
 Res = beam_lib:strip_files(mad_repl:wildcards(["{apps,deps,lib}/*/ebin/*.beam","ebin/*.beam"])),
 mad:info("~p~n",[Res]),
 false.
