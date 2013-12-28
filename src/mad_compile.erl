-module(mad_compile).

-export([deps/1]).
-export([app/1]).
-compile(export_all).
-include("mad.hrl").


%% compile dependencies
deps([]) ->
    ok;
deps([H|T]) ->
    {Name, Repo} = mad_deps:name_and_repo(H),
    Co = case Repo of
             {_, _, V} ->
                 V;
             {_, _, V, _} ->
                 V
         end,
    Co1 = mad_deps:checkout_to(Co),
    DepName = mad_deps:make_dep_name(Name, Co1),
    case get(DepName) of
        compiled ->
            ok;
        _ ->
            dep(DepName)
    end,
    deps(T).

%% compile a dependency
dep(DepName) ->
    %% check dependencies of the dependency
    DepPath = mad_deps:path(DepName),
    RebarFile = mad_utils:rebar_conf_file(DepPath),
    Conf = mad_utils:consult(RebarFile),
    Conf1 = mad_utils:script(DepPath, Conf),
    deps(mad_utils:get_value(deps, Conf1, [])),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(DepPath, Conf1),
    code:add_paths(LibDirs),

    %% compile sub_dirs and add them to path
    SubDirs = mad_utils:sub_dirs(DepPath, Conf),
    lists:foreach(fun app/1, SubDirs),

    SrcDir = mad_utils:src(DepPath),
    Files = erl_files(SrcDir) ++ app_src_files(SrcDir),
    case Files of
        [] ->
            ok;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),
            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            mad_utils:exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, IncDir, EbinDir, Opts), Files),
            put(DepName, compiled)
    end.

app(Dir) ->
    Conf = mad_utils:consult(mad_utils:rebar_conf_file(Dir)),
    Conf1 = mad_utils:script(Dir, Conf),
    SrcDir = mad_utils:src(Dir),
    Files = erl_files(SrcDir) ++ app_src_files(SrcDir),
    case Files of
        [] ->
            ok;
        Files ->
            IncDir = mad_utils:include(Dir),
            EbinDir = mad_utils:ebin(Dir),
            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            mad_utils:exec("mkdir", ["-p", EbinDir]),
            lists:foreach(compile_fun(SrcDir, IncDir, EbinDir, Opts), Files),
            code:add_path(EbinDir)
    end.

compile_fun(SrcDir, IncDir, EbinDir, Opts) ->
    fun(F) ->
            code:add_path(EbinDir),
            F1 = filename:join(SrcDir, F),
            case is_app_src(F1) of
                false ->
                    io:format("Compiling ~s~n", [F1]),
                    compile:file(F1, ?COMPILE_OPTS(IncDir, EbinDir) ++ Opts);
                true ->
                    AppFile = filename:join(EbinDir, app_src_to_app(F1)),
                    io:format("Writing ~s~n", [AppFile]),
                    mad_utils:exec("cp", [F1, AppFile])
            end
    end.

erl_files(Dir) ->
    filelib:fold_files(Dir, ".erl", true, fun(F, Acc) -> [F|Acc] end, []).

app_src_files(Dir) ->
    filelib:fold_files(Dir, ".app.src", true, fun(F, Acc) -> [F|Acc] end, []).

is_app_src(Filename) ->
    Filename =/= filename:rootname(Filename, ".app.src").

app_src_to_app(Filename) ->
    filename:basename(Filename, ".app.src") ++ ".app".
