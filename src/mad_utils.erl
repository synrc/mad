-module(mad_utils).

-export([cwd/0]).
-export([exec/2]).
-export([home/0]).
-export([consult/1]).
-export([rebar_conf/1]).
-export([src/1]).
-export([include/1]).
-export([ebin/1]).
-export([deps/1]).
-export([get_value/3]).
-export([script/2]).
-export([sub_dirs/2]).
-export([lib_dirs/2]).
-export([https_to_git/1]).
-export([git_to_https/1]).
-export([last_modified/1]).

-type directory() :: string().


%% get current working directory
-spec cwd() -> directory().
cwd() ->
    {ok, Cwd} = file:get_cwd(),
    Cwd.

%% execute a shell command
exec(Cmd, Opts) ->
    Opts1 = [" " ++ X || X <- Opts],
    os:cmd(Cmd ++ lists:concat(Opts1)).

%% return $HOME
-spec home() -> directory().
home() ->
    %% ~/
    {ok, [[H|_]]} = init:get_argument(home),
    H.

-spec consult(file:name_all()) -> [term()].
consult(File) ->
    AbsFile = filename:absname(File),
    case file:consult(AbsFile) of
        {ok, V} ->
            V;
        _ ->
            []
    end.

-spec rebar_conf(directory()) -> [term()].
rebar_conf(Dir) ->
    Dir1 = filename:absname(Dir),
    consult(filename:join(Dir1, "rebar.config")).

-spec src(directory()) -> directory().
src(Dir) ->
    %% Dir/src
    filename:join(Dir, "src").

-spec include(directory()) -> directory().
include(Dir) ->
    %% Dir/include
    filename:join(Dir, "include").

-spec ebin(directory()) -> directory().
ebin(Dir) ->
    %% Dir/ebin
    filename:join(Dir, "ebin").

-spec deps(file:name_all()) -> [term()].
deps(File) ->
    get_value(deps, consult(File), []).

-spec get_value(term(), [{term(), term()}], Default) -> term() | Default.
get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default
    end.

-spec script(directory(), [term()]) -> [term()].
script(Dir, Conf) ->
    File = filename:join(Dir, "rebar.config.script"),
    case file:script(File, [{'CONFIG', Conf}]) of
        {ok, Out} ->
            Out;
        {error, _} ->
            Conf
    end.

-spec sub_dirs(directory(), [term()]) -> [directory()].
sub_dirs(Cwd, Conf) ->
    sub_dirs(Cwd, get_value(sub_dirs, Conf, []), []).

-spec sub_dirs(directory(), [term()], [term()]) -> [directory()].
sub_dirs(_, [], Acc) ->
    Acc;
sub_dirs(Cwd, [Dir|T], Acc) ->
    SubDir = filename:join(Cwd, Dir),
    Conf = rebar_conf(SubDir),
    Conf1 = script(SubDir, Conf),
    Acc1 = sub_dirs(SubDir, get_value(sub_dirs, Conf1, []), Acc ++ [SubDir]),
    sub_dirs(Cwd, T, Acc1).

-spec lib_dirs(directory(), [term()]) -> [directory()].
lib_dirs(Cwd, Conf) ->
    lib_dirs(Cwd, get_value(lib_dirs, Conf, []), []).

-spec lib_dirs(directory(), [term()], [term()]) -> [directory()].
lib_dirs(_, [], Acc) ->
    Acc;
lib_dirs(Cwd, [H|T], Acc) ->
    Dirs = filelib:wildcard(filename:join([Cwd, H, "*", "ebin"])),
    lib_dirs(Cwd, T, Acc ++ Dirs).

-spec https_to_git(string()) -> string().
https_to_git(X) ->
    re:replace(X, "https://", "git://", [{return, list}]).

-spec git_to_https(string()) -> string().
git_to_https(X) ->
    re:replace(X, "git://", "https://", [{return, list}]).

-spec last_modified(file:name_all()) -> Seconds :: non_neg_integer().
last_modified(File) ->
    case filelib:last_modified(File) of
        0 ->
            0;
        Else ->
            calendar:datetime_to_gregorian_seconds(Else)
    end.
