-module(mad).

-export([clone_deps/1]).
-export([compile/1]).
-export([compile_app/1]).
-export([compile_deps/1]).
-export([update_path/1]).
-export([init/0]).

-define(DEPS_PATH, filename:join([home(), ".otp", "deps"])).
-define(COMPILE_OPTS(Inc, Ebin), [report, {i, Inc}, {outdir, Ebin}]).


clone_deps(RebarFile) ->
    case deps(RebarFile) of
        {ok, Deps} ->
            exec("mkdir", ["-p", ?DEPS_PATH]),
            do_clone_deps(Deps);
        {error, _} ->
            ok
    end.

%% compile dependencies and the app
compile(Dir) ->
    RebarFile = rebar_conf_file(Dir),
    case deps(RebarFile) of
        {ok, Deps} ->
            compile_deps(Deps);
        {error, _} ->
            ok
    end,
    compile_app(Dir).

compile_app(Dir) ->
    AbsDir = filename:absname(Dir),
    SrcDir = src(AbsDir),
    IncDir = include(AbsDir),
    case erl_files(SrcDir) of
        [] ->
            ok;
        Files ->
            EbinDir = ebin(AbsDir),
            exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files)
    end.

compile_deps([]) ->
    ok;
compile_deps([{Name, _, Repo}|T]) ->
    Name1 = atom_to_list(Name),
    {_, _, Co} = Repo,
    %% branch/tag it should checkout to
    Co1 = case Co of
              {_, V} -> V;
              Else -> Else
          end,
    Name2 = make_dep_name(Name1, Co1),

    %% check dependencies of the dependency
    RebarFile = rebar_conf_file(dep_path(Name2)),
    case deps(RebarFile) of
        {ok, Deps} ->
            compile_deps(Deps);
        {error, _} ->
            ok
    end,

    SrcDir = src(dep_path(Name2)),
    EbinDir = ebin(dep_path(Name2)),
    IncDir = include(dep_path(Name2)),
    case erl_files(SrcDir) of
        [] ->
            ok;
        Files ->
            exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files)
    end,
    compile_deps(T).

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
    filename:join([X, "rebar.config"]).

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
    Acc1 = case deps(RebarFile) of
               {ok, Deps} ->
                   deps_path(Deps, []);
               {error, _} ->
                   []
           end,
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
    case file:consult(RebarFile) of
        {ok, Conf} ->
            case lists:keyfind(deps, 1, Conf) of
                {deps, Deps} ->
                    {ok, Deps};
                _ ->
                    {ok, []}
            end;
        Else ->
            Else
    end.

do_clone_deps([]) ->
    ok;
do_clone_deps([{Name, _, Repo}|T]) ->
    Name1 = atom_to_list(Name),
    {Cmd, Url, Co} = Repo,

    %% branch/tag it should checkout to
    Co1 = case Co of
              {_, V} -> V;
              Else -> Else
          end,
    Name2 = make_dep_name(Name1, Co1),

    %% command options: clone url path/to/dep -b Branch/Tag
    Opts = ["clone", Url, dep_path(Name2), "-b", Co1],
    io:format("dependency: ~s~n", [Name1]),

    %% run the command
    exec(Cmd, Opts),

    %% check dependencies of the dependency
    RebarFile = rebar_conf_file(dep_path(Name2)),
    case deps(RebarFile) of
        {ok, Deps} ->
            do_clone_deps(Deps);
        {error, _} ->
            ok
    end,
    do_clone_deps(T).

erl_files(Dir) ->
    filelib:wildcard(filename:join([Dir, "*.erl"])).
