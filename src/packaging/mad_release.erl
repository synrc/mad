-module(mad_release).
-description("MAD precompiled binary packages").
-copyright('Synrc Research Center, s.r.o').
-compile(export_all).

% depot releases for synrc.com/apps

contains(X,String,Acc) ->
    case string:str(String,atom_to_list(X)) > 0 of true -> [{X}|Acc]; _ -> [] end.

wildcards(Depot,X,Pattern) ->
    mad_repl:wildcards([Depot++atom_to_list(X)++Pattern]).

atomlist(TARGETS) ->
    string:join(lists:map(fun(X) -> atom_to_list(X) end,TARGETS),",").

depot_release(Name) ->
    mad_plan:main([]),
    TARGETS   = [beam,ling],
    HOSTS     = [mac,bsd,windows],
    Depot     = "/Users/5HT/depot/synrc/synrc.com/apps/",
    {ok,Apps} = file:consult(Depot++"index.txt"),
    Files     = lists:flatten([[
                    lists:foldl(fun(A,Acc) -> [{A}|Acc] end,
                        [], wildcards(Depot,X,lists:concat(["/ebin/**/*.{app,",atomlist(TARGETS),"}"]))),
                    lists:foldl(fun(B,Acc)->[contains(P,B,Acc)||P<-HOSTS] end,
                        [], wildcards(Depot,X,"/{bin,priv}/**/*")) ]
    || {_,[X],_} <- lists:flatten(Apps) ]),
    io:format("DEPOT Apps: ~p~n",[Files]),
    {ok,Name}.

release([])              -> io:format("REL1~n"),
                            release(["script"]);
release(["depot"])       -> release(["depot", "sample"]);
release(["beam"])        -> release(["beam",  "sample"]);
release(["ling"])        -> release(["ling",  "sample"]);
release(["script"])      -> io:format("REL2~n"),
                            release(["script","sample"]);
release(["ling",N])      -> mad_ling:ling(N);
release(["script",N])    -> io:format("REL3~n"),
                            mad_bundle:main(N);
release(["depot",N])     -> mad_release:depot_release(N);
release(["beam",N])      -> mad_systools:beam_release(N);
release([X])             -> io:format("REL5~n"),
                            release(["script",X]).
