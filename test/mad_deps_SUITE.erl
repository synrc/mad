-module(mad_deps_SUITE).

-export([all/0]).
-export([repos_path/1]).
-export([path/1]).
-export([name_and_repo/1]).
-export([checkout_to/1]).
-export([get_publisher/1]).
-export([fetch/1]).

-import(helper, [get_value/2]).


all() ->
    [repos_path, path, name_and_repo, checkout_to, get_publisher, fetch].

repos_path(_) ->
    Path = filename:join([os:cmd("echo -n $HOME"), ".mad", "repos"]),
    Path = mad_deps:repos_path().

path(_) ->
    Path = filename:join([os:cmd("echo -n $HOME"), ".mad", "repos",
                          "publisher", "repo"]),
    Path = mad_deps:path("publisher", "repo").

name_and_repo(_) ->
    Dep = {x,".*",{git,"blah, blah..",{tag,"v0.8.10"}}},
    {"x",{git,"blah, blah..", {tag,"v0.8.10"}}} = mad_deps:name_and_repo(Dep).

checkout_to(_) ->
    "v0.8.10" = mad_deps:checkout_to({tag, "v0.8.10"}),
    "develop" = mad_deps:checkout_to({branch, "develop"}).

get_publisher(_) ->
    "erlang" = mad_deps:get_publisher("git://github.com/erlang/otp.git"),
    "s1n4" = mad_deps:get_publisher("https://github.com/s1n4/mad"),
    "xyz" = mad_deps:get_publisher("https://bitbucket.org/xyz/repo").

fetch(Config) ->
    DataDir = get_value(data_dir, Config),
    DepsDir = filename:join(DataDir, "deps"),
    os:cmd("rm -rf " ++ DepsDir),
    %% make repos and deps directories
    os:cmd("mkdir -p " ++ mad_deps:repos_path()),
    os:cmd("mkdir -p " ++ DepsDir),
    Deps = [{mad, ".*",
             {git, "git://github.com/s1n4/mad.git", {branch, "master"}}
            }],
    mad_deps:fetch(DataDir, Config, "rebar.config", Deps),
    {ok, _} = file:list_dir(filename:join(DepsDir, "mad")),
    os:cmd("rm -rf " ++ DepsDir).
