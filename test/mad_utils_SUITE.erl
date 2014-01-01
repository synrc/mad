-module(mad_utils_SUITE).

-export([all/0]).
-export([cwd/1]).
-export([home/1]).
-export([exec/1]).
-export([consult/1]).
-export([rebar_conf/1]).
-export([src/1]).
-export([include/1]).
-export([ebin/1]).
-export([deps/1]).
-export([script/1]).

-import(helper, [get_value/2]).


all() ->
    [cwd, exec, home, consult, rebar_conf, src, include, ebin, deps, script].

cwd(_) ->
    Cwd = os:cmd("pwd") -- "\n",
    Cwd = mad_utils:cwd().

exec(_) ->
    "xyz" = mad_utils:exec("echo", ["-n", "xyz"]).

home(_) ->
    Home = os:cmd("echo $HOME") -- "\n",
    Home = mad_utils:home().

consult(Config) ->
    File = filename:join(get_value(data_dir, Config), "rebar"),
    [] = mad_utils:consult(File),
    [{deps, [
             {mad, ".*", {git, "git://github.com/s1n4/mad.git",
                          {branch, "master"}}}
            ]},
     {erl_opts, [d, 'X']}] = mad_utils:consult(File ++ ".config").

rebar_conf(Config) ->
    [] = mad_utils:rebar_conf("."),
    [{deps, [
             {mad, ".*", {git, "git://github.com/s1n4/mad.git",
                          {branch, "master"}}}
            ]},
     {erl_opts, [d, 'X']}] = mad_utils:rebar_conf(get_value(data_dir, Config)).

src(_) ->
    "/path/to/app/src" = mad_utils:src("/path/to/app").

include(_) ->
    "/path/to/app/include" = mad_utils:include("/path/to/app").

ebin(_) ->
    "/path/to/app/ebin" = mad_utils:ebin("/path/to/app").

deps(Config) ->
    File = filename:join(get_value(data_dir, Config), "rebar"),
    [] = mad_utils:deps(File),
    [{mad, ".*",
      {git, "git://github.com/s1n4/mad.git", {branch, "master"}
      }}] = mad_utils:deps(File ++ ".config").

script(Config) ->
    [a, b, c] = mad_utils:script(mad_utils:cwd(), [a, b, c]),
    Dir = get_value(data_dir, Config),
    [{sub_dirs, ["sub_dir1", "sub_dir2"]},
     a, b, c] = mad_utils:script(Dir, [a, b, c]).
