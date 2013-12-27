-module(mad).

-export([clone_deps/1]).
-export([compile/1]).
-export([compile_app/1]).
-export([compile_deps/1]).
-export([update_path/1]).
-export([init/0]).

-define(DEPS_PATH, filename:join([home(), ".otp", "deps"])).
-define(COMPILE_OPTS(Inc, Ebin), [report, {i, Inc}, {outdir, Ebin}]).


%% clone dependencies
clone_deps(RebarFile) ->
    Conf = consult(RebarFile),
    case get_value(deps, Conf, []) of
        [] ->
            ok;
        Deps ->
            exec("mkdir", ["-p", ?DEPS_PATH]),
            LibDirs = get_value(lib_dirs, Conf, []),
            %% check sub_dirs if they have something to be cloned
            check_libdirs(LibDirs, fun do_clone_deps/1),
            do_clone_deps(Deps)
    end.

%% compile dependencies and the app
compile(Dir) ->
    RebarFile = rebar_conf_file(Dir),
    Conf = consult(RebarFile),
    %% check sub_dirs if they have something to be compiled
    check_libdirs(get_value(lib_dirs, Conf, []), fun compile_deps/1),
    check_libdirs(get_value(lib_dirs, Conf, []), fun compile_app/1),
    compile_deps(get_value(deps, Conf, [])),
    compile_app(Dir).

%% compile a project according to the conventions
compile_app(Dir) ->
    AbsDir = filename:absname(Dir),
    SrcDir = src(AbsDir),
    case erl_files(SrcDir) of
        [] ->
            ok;
        Files ->
            IncDir = include(AbsDir),
            EbinDir = ebin(AbsDir),
            exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files)
    end.

%% compile dependencies
compile_deps([]) ->
    ok;
compile_deps([H|T]) ->
    {Name, Repo} = name_and_repo(H),
    Co = case Repo of
             {_, _, V} ->
                 V;
             {_, _, V, _} ->
                 V
         end,
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),
    case get(DepName) of
        compiled ->
            ok;
        _ ->
            compile_dep(H)
    end,
    compile_deps(T).

compile_dep(Dep) ->
    {Name, Repo} = name_and_repo(Dep),
    Co = case Repo of
             {_, _, V} ->
                 V;
             {_, _, V, _} ->
                 V
         end,

    %% branch/tag it should checkout to
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),

    %% check dependencies of the dependency
    RebarFile = rebar_conf_file(dep_path(DepName)),
    compile_deps(deps(RebarFile)),

    SrcDir = src(dep_path(DepName)),
    case erl_files(SrcDir) of
        [] ->
            ok;
        Files ->
            EbinDir = ebin(dep_path(DepName)),
            IncDir = include(dep_path(DepName)),
            exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files),
            put(DepName, compiled)
    end.

%% add application directory (its ebin) and its dependencies to the code path
update_path(Dir) ->
    AbsDir = filename:absname(Dir),
    Ebin = ebin(AbsDir),
    code:add_path(Ebin),

    RebarFile = rebar_conf_file(AbsDir),
    case deps(RebarFile) of
        {ok, Deps} ->
            code:add_paths(deps_ebin(Deps));
        {error, _} ->
            ok
    end.

init() ->
    {ok, Cwd} = file:get_cwd(),
    update_path(Cwd).


%% internal
exec(Cmd, Opts) ->
    Opts1 = [concat([" ", X]) || X <- Opts],
    os:cmd(concat([Cmd, concat(Opts1)])).

concat(L) ->
    lists:concat(L).

make_dep_name(Name, Suffix) ->
    %% Name-Suffix
    concat([Name, "-", Suffix]).

home() ->
    %% ~/
    {ok, [[H|_]]} = init:get_argument(home),
    H.

dep_path(X) ->
    %% ~/.otp/deps/X
    filename:join([?DEPS_PATH, X]).

rebar_conf_file(X) ->
    filename:join([filename:absname(X), "rebar.config"]).

ebin(X) ->
    %% X/ebin
    filename:join([dep_path(X), "ebin"]).

src(X) ->
    %% X/src
    filename:join([dep_path(X), "src"]).

include(X) ->
    %% X/include
    filename:join([X, "include"]).

deps_path(Deps) ->
    deps_path(Deps, []).

deps_path([], Acc) ->
    Acc;
deps_path([{Name, _, Repo}|T], Acc) ->
    Name1 = atom_to_list(Name),
    {_, _, Co} = Repo,
    %% branch/tag it should checkout to
    Co1 = case Co of
              {_, V} -> V;
              Else -> Else
          end,
    Name2 = make_dep_name(Name1, Co1),
    RebarFile = rebar_conf_file(dep_path(Name2)),
    Conf = consult(RebarFile),
    Deps = get_value(deps, Conf, []),
    %% TODO: handle sub_dirs
    Acc1 = deps_path(Deps, []),
    deps_path(T, [dep_path(Name2)|Acc ++ Acc1]).

deps_ebin(Deps) ->
    deps_ebin(deps_path(Deps), []).

deps_ebin([], Acc) ->
    Acc;
deps_ebin([H|T], Acc) ->
    deps_ebin(T, [filename:join([H, "ebin"])|Acc]).

is_app_src(Filename) ->
    Filename =/= filename:rootname(Filename, ".app.src").

app_src_to_app(Filename) ->
    filename:join([filename:basename(Filename, ".app.src") ++ ".app"]).

compile_fun(SrcDir, EbinDir, IncDir) ->
    fun(F) ->
            F1 = filename:join([SrcDir, F]),
            case is_app_src(F1) of
                false ->
                    io:format("Compiling ~s~n", [F1]),
                    compile:file(F1, ?COMPILE_OPTS(IncDir, EbinDir));
                true ->
                    AppFile = filename:join([EbinDir, app_src_to_app(F1)]),
                    io:format("Writing ~s~n", [AppFile]),
                    exec("cp", [F1, AppFile])
            end,
            code:add_path(EbinDir)
    end.

%% read rebar.config file and return the {deps, V}
deps(RebarFile) ->
    get_value(deps, consult(RebarFile), []).

do_clone_deps([]) ->
    ok;
do_clone_deps([H|T]) when is_tuple(H) =:= false ->
    do_clone_deps(T);
do_clone_deps([H|T]) ->
    {Name, Repo} = name_and_repo(H),
    {_, _, Co} = case Repo of
                     V={_, _, _} ->
                         V;
                     {_Cmd, _Url, _Co, _} ->
                         {_Cmd, _Url, _Co}
                 end,
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),
    case get(DepName) of
        cloned ->
            ok;
        _ ->
            clone_dep(H)
    end,
    do_clone_deps(T).

clone_dep(Dep) ->
    {Name, Repo} = name_and_repo(Dep),
    {Cmd, Url, Co} = case Repo of
                         V={_, _, _} ->
                             V;
                         {_Cmd, _Url, _Co, _} ->
                             {_Cmd, _Url, _Co}
                     end,
    Co1 = checkout_to(Co),
    DepName = make_dep_name(Name, Co1),

    %% command options: clone url path/to/dep -b Branch/Tag
    DepPath = dep_path(DepName),
    Opts = ["clone", Url, DepPath],
    io:format("dependency: ~s~n", [Name]),
    %% clone
    exec(Cmd, Opts),

    %% checkout to Co1
    {ok, Cwd} = file:get_cwd(),
    ok = file:set_cwd(DepPath),
    exec(Cmd, ["checkout", Co1]),
    ok = file:set_cwd(Cwd),

    put(DepName, cloned),

    %% check dependencies of the dependency
    RebarFile = rebar_conf_file(dep_path(DepName)),
    do_clone_deps(deps(RebarFile)).

erl_files(Dir) ->
    filelib:wildcard(filename:join([Dir, "*.erl"])).

checkout_to({_, V}) -> V;
checkout_to(Else) -> Else.

name_and_repo({Name, _, Repo}) ->
    {atom_to_list(Name), Repo};
name_and_repo({Name, _, Repo, _}) ->
    {atom_to_list(Name), Repo}.

consult(File) ->
    AbsFile = filename:absname(File),
    case file:consult(AbsFile) of
        {ok, V} ->
            V;
        _ ->
            []
    end.

get_value(Key, Opts, Default) ->
    case lists:keyfind(Key, 1, Opts) of
        {Key, Value} ->
            Value;
        _ -> Default
    end.

check_libdirs([], _) ->
    ok;
check_libdirs([H|T], Fun) ->
    Dir = filename:absname(H),
    Conf = rebar_conf_file(Dir),
    check_libdirs(get_value(sub_dirs, Conf, []), Fun),
    Fun(get_value(deps, Conf, [])),
    check_libdirs(T, Fun).

%% schema_to_git(X) ->
%%     re:replace(X, "https://", "git://", [{return, list}]).

%% schema_to_https(X) ->
%%     re:replace(X, "git://", "https://", [{return, list}]).
