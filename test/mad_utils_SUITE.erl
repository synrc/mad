-module(mad_utils_SUITE).

-export([all/0]).
-export([cwd/1]).
-export([exec/1]).
-export([home/1]).
-export([consult/1]).
-export([src/1]).
-export([include/1]).
-export([ebin/1]).
-export([deps/1]).
-export([get_value/1]).
-export([script/1]).
-export([lib_dirs/1]).
-export([sub_dirs/1]).
-export([https_to_git/1]).
-export([git_to_https/1]).
-export([last_modified/1]).

-import(helper, [get_value/2]).


all() ->
    [
     cwd, exec, home, consult, src, include, ebin, deps, get_value, script,
     lib_dirs, sub_dirs, https_to_git, git_to_https, last_modified
    ].

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

get_value(_) ->
    Opts = [{numbers, [0,1,2,"and so on"]}],
    patience_dude = mad_utils:get_value(gimme_wat_I_want, Opts, patience_dude),
    [0,1,2,"and so on"] = mad_utils:get_value(numbers, Opts, undefined).

script(Config) ->
    [a, b, c] = mad_utils:script("rebar.config", [a, b, c]),
    File = filename:join(get_value(data_dir, Config), "rebar.config"),
    [{sub_dirs, ["sub_dir1", "sub_dir2"]},
     a, b, c] = mad_utils:script(File, [a, b, c]).

sub_dirs(Config) ->
    ["/sub_dir0"] = mad_utils:sub_dirs("/", "rebar.config",
                                       [{sub_dirs, ["sub_dir0"]}]),
    DataDir = get_value(data_dir, Config),
    SD1 = filename:absname(filename:join(DataDir, "sub_dir1")),
    SD2 = filename:join(SD1, "trap"),
    SD3 = filename:absname(filename:join(DataDir, "sub_dir2")),
    SD4 = filename:join(SD3, "time-machine"),
    [
     SD1, SD2, SD3, SD4
    ] =  mad_utils:sub_dirs(DataDir, "rebar.config",
                            [{sub_dirs, ["sub_dir1", "sub_dir2"]}]).

lib_dirs(Config) ->
    [] = mad_utils:lib_dirs("/", [{lib_dirs, ["lib_dir0"]}]),
    DataDir = get_value(data_dir, Config),
    LD1 = filename:absname(filename:join([DataDir, "lib_dir1", "app1", "ebin"])),
    LD2 = filename:absname(filename:join([DataDir, "lib_dir2", "app2", "ebin"])),
    [LD1, LD2] = mad_utils:lib_dirs(DataDir,
                                    [{lib_dirs, ["lib_dir1", "lib_dir2"]}]).

https_to_git(_) ->
    Repo = "https://github.com/erlang/otp.git",
    "git://github.com/erlang/otp.git" = mad_utils:https_to_git(Repo).

git_to_https(_) ->
    Repo = "git://github.com/s1n4/some_secret.git",
    "https://github.com/s1n4/some_secret.git" = mad_utils:git_to_https(Repo).

last_modified(Config) ->
    0 = mad_utils:last_modified("you_mad_bro"),
    DataDir = get_value(data_dir, Config),
    true = (mad_utils:last_modified(DataDir ++ "rebar.config") > 0).
