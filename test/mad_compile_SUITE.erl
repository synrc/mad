-module(mad_compile_SUITE).

-export([all/0]).
-export([deps/1]).

-import(helper, [get_value/2]).


all() ->
    [deps].

deps(Config) ->
    DataDir = get_value(data_dir, Config),
    Deps = [{one, "", {}}, {two, "", {}}],
    ok = mad_compile:deps(DataDir, Deps),
    pong = one:ping(),
    pong = two:ping(),
    ok = application:load(one),
    ok = application:load(two),
    {ok, [one]} = application:get_key(one, modules),
    {ok, [two]} = application:get_key(two, modules).
