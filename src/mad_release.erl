-module(mad_release).
-compile(export_all).

release(["beam",N])      -> mad_systools:beam_release(N);
release(["script",N])    -> mad_escript:main(N);
release(["beam"])        -> release(["beam",  "sample"]);
release(["script"])      -> release(["script","sample"]);
release([])              -> release(["script"]);
release([X])             -> release(["script",X]).

strip(_) ->
    beam_lib:strip_files(
    mad_repl:wildcards(["{apps,deps,lib}/*/ebin/*.beam","ebin/*.beam"])),
    {ok,[]}.

% TOP SORT

rm_dups([]) -> [];
rm_dups([H|T]) -> case lists:member(H, T) of true -> rm_dups(T); false -> [H|rm_dups(T)] end.
sort(Pairs) -> iterate(Pairs, [], lhs(Pairs) ++ rhs(Pairs)).
lhs(L) -> [X || {X, _, _} <- L].
rhs(L) -> [Y || {_, Y, _} <- L].
rm_pairs(L1, L2) -> [All || All = {X, _Y, _} <- L2, not lists:member(X, L1)].
subtract(L1, L2) -> [X || X <- L1, not lists:member(X, L2)].
iterate([], L, All) -> {ok,rm_dups(L ++ subtract(All, L))};
iterate(P, L, All) -> case subtract(lhs(P), rhs(P)) of [] -> P;
                           Lhs -> iterate(rm_pairs(Lhs, P), L ++ Lhs, All) end.

appdir(A) -> filename:join(lists:reverse(tl(tl(lists:reverse(filename:split(A)))))).

triples() ->
    lists:flatten([ case
       file:consult(F) of
         {ok,[{application,Name,Opt}]} ->
              Apps1 = proplists:get_value(included_applications,Opt,[]),
              Apps2 = proplists:get_value(applications,Opt,[]),
              Apps = lists:usort(Apps1++Apps2),
              Vsn  = proplists:get_value(vsn,Opt,[]),
              [ case lists:member(A,mad_repl:system()) of
                     false -> {A,Name,{Vsn,appdir(filename:absname(F))}};
                     true -> [{A,Name,{Vsn,appdir(filename:absname(F))}}]++ system_deps(A) end || A <- Apps ];
         {error,_} ->
            mad:info("AppName: ~p~n",[F]), skip
    end || F <- mad_repl:wildcards(["{apps,deps}/*/ebin/*.app","ebin/*.app"]), not filelib:is_dir(F) ]).

orderapps() ->
    Apps = triples(),
    case sort(lists:flatten(Apps)) of
         {ok,Sorted} -> {ok,Sorted};
         _Return -> {error,"Cycling apps."} end.

system_deps(A) ->
    F = code:where_is_file(lists:concat([A,".app"])),
    case file:consult(F) of
         {ok,[{application,Name,Opt}]} ->
              Vsn = proplists:get_value(vsn,Opt,[]),
              [ {_A,Name,{Vsn,appdir(F)}} || _A <- proplists:get_value(applications,Opt,[]) ];
         {error,_} -> [] end.

resolve(_) ->
    case orderapps() of
         {ok,Ordered}   -> file:write_file(".applist",io_lib:format("~w",[Ordered])),
                           mad:info("Generated ~p~n",[Ordered]),
                           {ok,Ordered};
         {error,Reason} -> {error,Reason} end.
