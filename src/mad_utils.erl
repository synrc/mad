-module(mad_utils).
-copyright('Sina Samavati').
-compile(export_all).

%% internal
name_and_repo({Name, _, Repo}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo, _}) when is_list(Name) -> {Name, Repo};
name_and_repo({Name, _, Repo}) -> {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) -> {atom_to_list(Name), Repo};
name_and_repo({Name, Version}) when is_list(Name) -> {Name, Version};
name_and_repo({Name, Version}) -> {atom_to_list(Name), Version};
name_and_repo(Name) -> {Name,Name}.

cwd() -> {ok, Cwd} = file:get_cwd(), Cwd.
home() -> {ok, [[H|_]]} = init:get_argument(home), H.
consult(File) -> case file:consult(filename:absname(File)) of
                      {error,enoent} -> {ok,[]};
                      {error,E} -> {error,"rebar.config error:\n"++io_lib:format("~p\n",[E])};
                      {ok,V} -> {ok,V} end.

src(Dir) -> filename:join(Dir, "src").
include(Dir) -> filename:join(Dir, "include").
ebin(Dir) -> filename:join(Dir, "ebin").
priv(Dir) -> filename:join(Dir, "priv").
deps(File) -> get_value(deps, consult(File), []).

get_value(Key, Opts, undefined) -> get_value(Key, Opts, []);
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
    case consult(ConfigFile1) of
         {ok,Conf} ->
            Conf1 = mad_script:script(ConfigFile1, Conf, Dir),
             Acc1 = sub_dirs(SubDir, ConfigFile, get_value(sub_dirs, Conf1, []),
                    Acc ++ [SubDir]),
             sub_dirs(Cwd, ConfigFile, T, Acc1);
         {error,E} -> [] end.

lib_dirs(Cwd, Conf) -> lib_dirs(Cwd, get_value(lib_dirs, Conf, []), []).

raw_deps(Deps) -> raw_deps(Deps,[]).
raw_deps([],Res) -> Res;
raw_deps([D|Deps],Res) when is_tuple(D) -> raw_deps([element(1,D)|Deps],Res);
raw_deps([D|Deps],Res) -> raw_deps(Deps,[D|Res]).

lib_dirs(_, [], Acc) -> Acc;
lib_dirs(Cwd, [H|T], Acc) when is_tuple(H) -> lib_dirs(Cwd, [element(1,H)|T], Acc);
lib_dirs(Cwd, [H|T], Acc) ->
    Dirs = filelib:wildcard(filename:join([Cwd, H, "*", "include"])),
    lib_dirs(Cwd, T, Acc ++ Dirs).

last_modified(File) ->
    case filelib:last_modified(File) of
        0 -> 0;
        Else -> calendar:datetime_to_gregorian_seconds(Else) end.

to_atom(X) when is_atom(X) -> X;
to_atom(X) when is_list(X) -> list_to_atom(X);
to_atom(X) when is_binary(X) -> to_atom(binary_to_list(X));
to_atom(X) -> X.


verbose(Config,Message) ->
    case mad_utils:get_value(verbose, Config, 0) of
         0 -> skip;
         _ -> mad:info("~s",[binary_to_list(Message)]) end.

compile(_,_,_,_,_) -> false.

configs() ->
    Cwd            = try fs:path() catch _:_ -> cwd() end,
    ConfigFile     = "rebar.config",
    ConfigFileAbs  = filename:join(Cwd, ConfigFile),
    case mad_utils:consult(ConfigFileAbs) of
         {error,E} -> {error,E};
         {ok,Conf} -> Conf1 = mad_script:script(ConfigFileAbs, Conf, ""),
                      {ok,{Cwd,ConfigFile,Conf1}} end.
