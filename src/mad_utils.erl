-module(mad_utils).
-copyright('Sina Samavati').
-compile(export_all).

cwd() -> {ok, Cwd} = file:get_cwd(), Cwd.

home() -> {ok, [[H|_]]} = init:get_argument(home), H.

consult(File) ->
    AbsFile = filename:absname(File),
    case file:consult(AbsFile) of
        {ok, V} ->
            V;
        _ ->
            []
    end.

src(Dir) -> filename:join(Dir, "src").
include(Dir) -> filename:join(Dir, "include").
ebin(Dir) -> filename:join(Dir, "ebin").
deps(File) -> get_value(deps, consult(File), []).

get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default end.

script(ConfigFile, Conf, _Name) ->
    File = ConfigFile ++ ".script",
    case file:script(File, [{'CONFIG', Conf}, {'SCRIPT', File}]) of
        {ok, {error,_}} -> Conf;
        {ok, Out} -> Out;
        {error, _} -> Conf
    end.

sub_dirs(Cwd, ConfigFile, Conf) ->
    sub_dirs(Cwd, ConfigFile, get_value(sub_dirs, Conf, []), []).

sub_dirs(_, _, [], Acc) -> Acc;
sub_dirs(Cwd, ConfigFile, [Dir|T], Acc) ->
    SubDir = filename:join(Cwd, Dir),
    ConfigFile1 = filename:join(SubDir, ConfigFile),
    Conf = consult(ConfigFile1),
    Conf1 = script(ConfigFile1, Conf, Dir),
    Acc1 = sub_dirs(SubDir, ConfigFile, get_value(sub_dirs, Conf1, []),
                    Acc ++ [SubDir]),
    sub_dirs(Cwd, ConfigFile, T, Acc1).

lib_dirs(Cwd, Conf) -> lib_dirs(Cwd, get_value(lib_dirs, Conf, []), []).

lib_dirs(_, [], Acc) -> Acc;
lib_dirs(Cwd, [H|T], Acc) ->
    Dirs = filelib:wildcard(filename:join([Cwd, H, "*", "ebin"])),
    lib_dirs(Cwd, T, Acc ++ Dirs).

last_modified(File) ->
    case filelib:last_modified(File) of
        0 -> 0;
        Else -> calendar:datetime_to_gregorian_seconds(Else) end.

to_atom(X) when is_atom(X) -> X;
to_atom(X) when is_list(X) -> list_to_atom(X);
to_atom(X) when is_binary(X) -> to_atom(binary_to_list(X));
to_atom(X) -> X.

atomize("com"++_) -> compile;
atomize("rep"++_) -> repl;
atomize("bun"++_) -> bundle;
atomize("dep"++_) -> deps;
atomize("pla"++_) -> plan;
atomize("app"++_) -> app;
atomize("lib"++_) -> lib;
atomize("sta"++_) -> start;
atomize("att"++_) -> attach;
atomize("sto"++_) -> stop;
atomize("cle"++_) -> clean;
atomize("rel"++_) -> release;
atomize(Else) -> Else.

atomize_params_commands(Params) -> atomize_params_commands(Params,[]).
atomize_params_commands([],New) -> New;
atomize_params_commands([H|T], New) -> atomize_params_commands(T,[atomize(H)|New]).

fold_params(Params) -> 
   Atomized = atomize_params_commands(Params),
   lists:foldl(fun(X,{Current,Result}) -> 
      case atomize(X) of
           X when is_atom(X) -> {[],[{X,Current}|Result]};
           E -> {[E|Current],Result} end
      end, {[],[]}, Atomized).

compile(_,_,_,_) -> ok.

