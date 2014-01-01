-module(mad_deps_SUITE).

-export([all/0]).
-export([container/1]).
-export([path/1]).
-export([name_and_repo/1]).
-export([checkout_to/1]).


all() ->
    [container, path, name_and_repo, checkout_to].

container(_) ->
    Path = filename:join([mad_utils:home(), ".mad", "container"]),
    Path = mad_deps:container().

path(_) ->
    Path = filename:join([mad_utils:home(), ".mad", "container", "X"]),
    Path = mad_deps:path("X").

name_and_repo(_) ->
    Dep = {x,".*",{git,"blah, blah..",{tag,"v0.8.10"}}},
    {"x",{git,"blah, blah..", {tag,"v0.8.10"}}} = mad_deps:name_and_repo(Dep).

checkout_to(_) ->
    "v0.8.10" = mad_deps:checkout_to({tag, "v0.8.10"}),
    "develop" = mad_deps:checkout_to({branch, "develop"}).
