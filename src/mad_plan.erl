-module(mad_plan).
-author('Maxim Sokhatsky').
-compile(export_all).

sort(Pairs) -> iterate(Pairs, [], all(Pairs)).
iterate([], L, All) -> {ok,remove_duplicates(L ++ subtract(All, L))};
iterate(Pairs, L, All) ->
    case subtract(lhs(Pairs), rhs(Pairs)) of
        []  -> io:format("Cycling Apps: ~p~n\r", [Pairs]);
        Lhs -> iterate(remove_pairs(Lhs, Pairs), L ++ Lhs, All) end.

remove_pairs(L1, L2) -> [All || All={X, _Y} <- L2, not lists:member(X, L1)].
all(L) -> lhs(L) ++ rhs(L).
lhs(L) -> [X || {X, _} <- L].
rhs(L) -> [Y || {_, Y} <- L].
subtract(L1, L2) -> [X || X <- L1, not lists:member(X, L2)].
remove_duplicates([]) -> [];
remove_duplicates([H|T]) ->
    case lists:member(H, T) of
          true  -> remove_duplicates(T);
          false -> [H|remove_duplicates(T)] end.

orderapps() ->
    Pairs = lists:flatten([ case 
       file:consult(F) of
         {ok,[{application,Name,Opt}]} -> 
              Apps = proplists:get_value(applications,Opt,[]),
              [ { A,Name} || A <- Apps ];
         {error,_} -> skip
    end || F <- filelib:wildcard("{apps,deps}/*/ebin/*.app"), not filelib:is_dir(F) ]),
    {ok,Sorted} = sort(Pairs),
    Sorted.

main(AppList) ->
    Ordered = orderapps(),
    io:format("Ordered: ~p~n\r",[Ordered]),
    file:write_file(".applist",io_lib:format("~w",[Ordered])),
    Ordered.
