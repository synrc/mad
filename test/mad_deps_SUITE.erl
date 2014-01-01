-module(mad_deps_SUITE).

-export([all/0]).
-export([container/1]).

all() ->
    [container].

container(_) ->
    true = (mad_deps:container() =:= "").
