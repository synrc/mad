-module(mad).

-export([deps/1]).
-export([clone_deps/1]).
-export([compile/1]).
-export([compile_deps/1]).
-export([update_path/1]).
-export([init/0]).


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

clone_deps(Deps) ->
    exec("mkdir", ["-p", deps_path()]),
    do_clone_deps(Deps).

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
    Opts = ["clone", Url, get_path(Name2), "-b", Co1],
    io:format("dependency: ~s~n", [Name1]),

    %% run the command
    exec(Cmd, Opts),

    %% check dependencies of the dependency
    case deps(rebar_config_file(Name2)) of
        {ok, Deps} ->
            do_clone_deps(Deps);
        {error, _} ->
            ok
    end,
    do_clone_deps(T).

%% compile dependencies and the app
compile(Dir) ->
    RebarFile = filename:join([Dir, "rebar.config"]),
    case deps(RebarFile) of
        {ok, Deps} ->
            compile_deps(Deps);
        {error, _} ->
            ok
    end,
    compile_app(Dir).

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
    SrcDir = src(get_path(Name2)),
    EbinDir = ebin(get_path(Name2)),
    IncDir = include(get_path(Name2)),
    case file:list_dir(SrcDir) of
        {ok, Files} ->
            exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files);
        {error, _} -> ok
    end,

    %% check dependencies of the dependency
    case deps(rebar_config_file(Name2)) of
        {ok, Deps} ->
            compile_deps(Deps);
        {error, _} ->
            ok
    end,
    compile_deps(T).

compile_app(Dir) ->
    SrcDir = src(Dir),
    IncDir = include(Dir),
    case file:list_dir(SrcDir) of
        {ok, Files} ->
            EbinDir = ebin(Dir),
            lists:foreach(compile_fun(SrcDir, EbinDir, IncDir), Files);
        {error, _} ->
            ok
    end.

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

deps_path() ->
    %% ~/.otp/deps
    filename:join([home(), ".otp", "deps"]).

get_path(X) ->
    %% ~/.otp/deps/X
    filename:join([deps_path(), X]).

rebar_config_file(X) ->
    %% ~/.otp/deps/X/rebar.config
    filename:join([get_path(X), "rebar.config"]).

ebin(X) ->
    %% X/ebin
    filename:join([get_path(X), "ebin"]).

src(X) ->
    %% X/src
    filename:join([get_path(X), "src"]).

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
    Acc1 = case deps(rebar_config_file(Name2)) of
               {ok, Deps} ->
                   deps_path(Deps, []);
               {error, _} ->
                   []
           end,
    deps_path(T, [get_path(Name2)|Acc ++ Acc1]).

deps_ebin(Deps) ->
    deps_ebin(deps_path(Deps), []).

deps_ebin([], Acc) ->
    Acc;
deps_ebin([H|T], Acc) ->
    deps_ebin(T, [filename:join([H, "ebin"])|Acc]).

%% add application directory (its ebin) and its dependencies to the code path
update_path(Dir) ->
    Ebin = filename:join([Dir, "ebin"]),
    code:add_path(Ebin),

    RebarFile = filename:join([Dir, "rebar.config"]),
    case deps(RebarFile) of
        {ok, Deps} ->
            code:add_paths(deps_ebin(Deps));
        {error, _} ->
            ok
    end.

is_app_src(Filename) ->
    Filename =/= filename:rootname(Filename, ".app.src").

app_src_to_app(Filename) ->
    filename:join([filename:basename(Filename, ".app.src") ++ ".app"]).

compile_fun(SrcDir, EbinDir, IncDir) ->
    fun(F) ->
            F1 = filename:join([SrcDir, F]),
            case is_app_src(F1) of
                false ->
                    io:format("Compiling ~s~n", [F]),
                    compile:file(F1, [{outdir, EbinDir}, {i, IncDir}]);
                true ->
                    AppF = app_src_to_app(F1),
                    io:format("Writing ebin/~s~n", [AppF]),
                    exec("cp", [F1, filename:join([EbinDir, AppF])])
            end
    end.

init() ->
    {ok, Cwd} = file:get_cwd(),
    update_path(Cwd).
