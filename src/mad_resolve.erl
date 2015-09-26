-module(mad_resolve).
-author('Maxim Sokhatsky').
-compile(export_all).

% dependency graph solver

sort(Pairs) -> iterate(Pairs, [], lhs(Pairs) ++ rhs(Pairs)).
lhs(L) -> [X || {X, _, _} <- L].
rhs(L) -> [Y || {_, Y, _} <- L].
rm_pairs(L1, L2) -> [All || All={X, _Y, _} <- L2, not lists:member(X, L1)].
subtract(L1, L2) -> [X || X <- L1, not lists:member(X, L2)].
iterate([], L, All) -> {ok,rm_dups(L ++ subtract(All, L))};
iterate(P, L, All) -> case subtract(lhs(P), rhs(P)) of [] -> P; Lhs -> iterate(rm_pairs(Lhs, P), L ++ Lhs, All) end.
rm_dups([]) -> [];
rm_dups([H|T]) -> case lists:member(H, T) of true -> rm_dups(T); false -> [H|rm_dups(T)] end.

appdir(A) -> filename:join(lists:reverse(tl(tl(lists:reverse(filename:split(A)))))).

triples() ->
    lists:flatten([ case
       file:consult(F) of
         {ok,[{application,Name,Opt}]} ->
              Apps = proplists:get_value(applications,Opt,[]),
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
         Return -> {error,{cycling_apps,Return}} end.

system_deps(A) ->
    F = code:where_is_file(lists:concat([A,".app"])),
    case file:consult(F) of
         {ok,[{application,Name,Opt}]} ->
              Vsn = proplists:get_value(vsn,Opt,[]),
              [ {_A,Name,{Vsn,appdir(F)}} || _A <- proplists:get_value(applications,Opt,[]) ];
         {error,_} -> [] end.

main(_) ->
    case orderapps() of
         {ok,Ordered}   -> mad:info("Ordered: ~p~n",[Ordered]),
                           file:write_file(".applist",io_lib:format("~w",[Ordered])), {ok,Ordered};
         {error,Reason} -> {error,Reason} end.
