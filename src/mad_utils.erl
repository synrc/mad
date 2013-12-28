-module(mad_utils).

-export([cwd/0]).
-export([exec/2]).
-export([concat/1]).
-export([home/0]).
-export([rebar_conf_file/1]).
-export([src/1]).
-export([include/1]).
-export([ebin/1]).
-export([consult/1]).
-export([deps/1]).
-export([get_value/3]).
-export([script/2]).
-export([sub_dirs/2]).
-export([lib_dirs/2]).
-export([https_to_git/1]).
-export([git_to_https/1]).


%% get current working directory
cwd() ->
    {ok, Cwd} = file:get_cwd(),
    Cwd.

%% execute a shell command
exec(Cmd, Opts) ->
    Opts1 = [concat([" ", X]) || X <- Opts],
    os:cmd(concat([Cmd, concat(Opts1)])).

concat(L) ->
    lists:concat(L).

%% return $HOME
home() ->
    %% ~/
    {ok, [[H|_]]} = init:get_argument(home),
    H.

rebar_conf_file(X) ->
    filename:absname(filename:join(X, "rebar.config")).

src(X) ->
    %% X/src
    filename:join(X, "src").

include(X) ->
    %% X/include
    filename:join(X, "include").

ebin(X) ->
    %% X/ebin
    filename:join(X, "ebin").

consult(File) ->
    AbsFile = filename:absname(File),
    case file:consult(AbsFile) of
        {ok, V} ->
            V;
        _ ->
            []
    end.

deps(File) ->
    get_value(deps, consult(File), []).

get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default
    end.

script(Dir, Conf) ->
    File = filename:join(Dir, "rebar.config.script"),
    case file:script(File, [{'CONFIG', Conf}]) of
        {ok, Out} ->
            Out;
        {error, _} ->
            Conf
    end.

sub_dirs(Cwd, Conf) ->
    sub_dirs(Cwd, get_value(sub_dirs, Conf, []), []).

sub_dirs(_, [], Acc) ->
    Acc;
sub_dirs(Cwd, [Dir|T], Acc) ->
    SubDir = filename:join(Cwd, Dir),
    Conf = consult(rebar_conf_file(SubDir)),
    Conf1 = script(SubDir, Conf),
    Acc1 = sub_dirs(SubDir, get_value(sub_dirs, Conf1, []), Acc),
    sub_dirs(Cwd, T, [SubDir|Acc1]).

lib_dirs(Cwd, Conf) ->
    lib_dirs(Cwd, get_value(lib_dirs, Conf, []), []).

lib_dirs(_, [], Acc) ->
    Acc;
lib_dirs(Cwd, [H|T], Acc) ->
    Dirs = filelib:wildcard(filename:join([Cwd, H, "*", "ebin"])),
    lib_dirs(Cwd, T, Acc ++ Dirs).

https_to_git(X) ->
    re:replace(X, "https://", "git://", [{return, list}]).

git_to_https(X) ->
    re:replace(X, "git://", "https://", [{return, list}]).
