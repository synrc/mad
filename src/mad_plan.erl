-module(mad_plan).
-author('Maxim Sokhatsky').
-compile(export_all).

sort(Pairs) -> iterate(Pairs, [], lhs(Pairs) ++ rhs(Pairs)).
lhs(L) -> [X || {X, _} <- L].
rhs(L) -> [Y || {_, Y} <- L].
rm_pairs(L1, L2) -> [All || All={X, _Y} <- L2, not lists:member(X, L1)].
subtract(L1, L2) -> [X || X <- L1, not lists:member(X, L2)].
iterate([], L, All) -> {ok,rm_dups(L ++ subtract(All, L))};
iterate(Pairs, L, All) -> case subtract(lhs(Pairs), rhs(Pairs)) of [] -> Pairs; Lhs -> iterate(rm_pairs(Lhs, Pairs), L ++ Lhs, All) end.
rm_dups([]) -> [];
rm_dups([H|T]) -> case lists:member(H, T) of true -> rm_dups(T); false -> [H|rm_dups(T)] end.

orderapps() ->
    Pairs = lists:flatten([ case 
       file:consult(F) of
         {ok,[{application,Name,Opt}]} ->
              Apps = proplists:get_value(applications,Opt,[]),
              [ case lists:member(A,mad_repl:system()) of
                     false -> {A,Name};
                     true -> [{A,Name}]++ system_deps(A) end || A <- Apps ];
         {error,_} ->
            io:format("AppName: ~p~n",[F]), skip
    end || F <- filelib:wildcard("{apps,deps}/*/ebin/*.app")  ++ 
                filelib:wildcard("ebin/*.app"), not filelib:is_dir(F) ]),
    case sort(lists:flatten(Pairs)) of
         {ok,Sorted} -> {ok,Sorted};
         Return -> {error,{cycling_apps,Return}} end.

system_deps(A) ->
    case file:consult(code:where_is_file(lists:concat([A,".app"]))) of
         {ok,[{application,Name,Opt}]} -> [ {A,Name} || A <- proplists:get_value(applications,Opt,[]) ];
         {error,_} -> [] end.

main(_) ->
    case orderapps() of
         {ok,Ordered}   -> io:format("Ordered: ~p~n\r",[Ordered]),
                           file:write_file(".applist",io_lib:format("~w",[Ordered])), false;
         {error,Reason} -> io:format("Ordering Error: ~p~n\r",[Reason]), true end.
