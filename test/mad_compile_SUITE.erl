-module(mad_compile_SUITE).

-export([all/0]).
-export([deps/1]).
-export([app/1]).

-import(helper, [get_value/2]).


all() ->
    [deps, app].

deps(Config) ->
    DataDir = get_value(data_dir, Config),
    DepsDir = filename:join("..", "mad_deps_SUITE_data"),
    ok = mad_compile:deps(DepsDataDir, "mad").
