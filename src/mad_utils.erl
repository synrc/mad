-module(mad_utils).
-copyright('Sina Samavati').
-compile(export_all).

-type directory() :: string().

-spec cwd() -> directory().
cwd() -> {ok, Cwd} = file:get_cwd(), Cwd.
exec(Cmd, Opts) -> os:cmd([Cmd," ",string:join(Opts," ")]).

-spec home() -> directory().
home() -> {ok, [[H|_]]} = init:get_argument(home), H.

-spec consult(file:name_all()) -> [term()].
consult(File) ->
    AbsFile = filename:absname(File),
    case file:consult(AbsFile) of
        {ok, V} ->
            V;
        _ ->
            []
    end.

-spec src(directory()) -> directory().
src(Dir) -> filename:join(Dir, "src").

-spec include(directory()) -> directory().
include(Dir) -> filename:join(Dir, "include").

-spec ebin(directory()) -> directory().
ebin(Dir) -> filename:join(Dir, "ebin").

-spec deps(file:name_all()) -> [term()].
deps(File) -> get_value(deps, consult(File), []).

-spec get_value(term(), [{term(), term()}], Default) -> term() | Default.
get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default end.

-spec script(file:name(), [term()]) -> [term()].
script(ConfigFile, Conf) ->
    File = ConfigFile ++ ".script",
    Filename = filename:basename(File),
    case file:script(File, [{'CONFIG', Conf}, {'SCRIPT', Filename}]) of
        {ok, {error,_}} -> Conf;
        {ok, Out} -> Out;
        {error, _} -> Conf
    end.

-spec sub_dirs(directory(), file:filename(), [term()]) -> [directory()].
sub_dirs(Cwd, ConfigFile, Conf) ->
    sub_dirs(Cwd, ConfigFile, get_value(sub_dirs, Conf, []), []).

-spec sub_dirs(directory(), file:filename(), [term()], [term()]) -> [directory()].
sub_dirs(_, _, [], Acc) -> Acc;
sub_dirs(Cwd, ConfigFile, [Dir|T], Acc) ->
    SubDir = filename:join(Cwd, Dir),
    ConfigFile1 = filename:join(SubDir, ConfigFile),
    Conf = consult(ConfigFile1),
    Conf1 = script(ConfigFile1, Conf),
    Acc1 = sub_dirs(SubDir, ConfigFile, get_value(sub_dirs, Conf1, []),
                    Acc ++ [SubDir]),
    sub_dirs(Cwd, ConfigFile, T, Acc1).

-spec lib_dirs(directory(), [term()]) -> [directory()].
lib_dirs(Cwd, Conf) -> lib_dirs(Cwd, get_value(lib_dirs, Conf, []), []).

-spec lib_dirs(directory(), [term()], [term()]) -> [directory()].
lib_dirs(_, [], Acc) -> Acc;
lib_dirs(Cwd, [H|T], Acc) ->
    Dirs = filelib:wildcard(filename:join([Cwd, H, "*", "ebin"])),
    lib_dirs(Cwd, T, Acc ++ Dirs).

-spec last_modified(file:name_all()) -> Seconds :: non_neg_integer().
last_modified(File) ->
    case filelib:last_modified(File) of
        0 -> 0;
        Else -> calendar:datetime_to_gregorian_seconds(Else) end.

to_atom(X) when is_atom(X) -> X;
to_atom(X) when is_list(X) -> list_to_atom(X);
to_atom(X) when is_binary(X) -> to_atom(binary_to_list(X));
to_atom(X) -> X.

