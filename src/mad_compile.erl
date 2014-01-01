-module(mad_compile).

-export([deps/1]).
-export([app/1]).

-include("mad.hrl").


%% compile dependencies
deps([]) ->
    ok;
deps([H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    case get(Name) of
        compiled ->
            ok;
        _ ->
            dep(Name)
    end,
    deps(T).

%% compile a dependency
dep(DepName) ->
    %% check dependencies of the dependency
    Cwd = mad_utils:cwd(),
    DepPath = filename:join([Cwd, "deps", DepName]),
    Conf = mad_utils:rebar_conf(DepPath),
    Conf1 = mad_utils:script(DepPath, Conf),
    deps(mad_utils:get_value(deps, Conf1, [])),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(DepPath, Conf1),
    code:add_paths(LibDirs),

    %% compile sub_dirs and add them to path
    SubDirs = mad_utils:sub_dirs(DepPath, Conf),
    lists:foreach(fun app/1, SubDirs),

    SrcDir = mad_utils:src(DepPath),
    Files = sort(erl_files(SrcDir)) ++ app_src_files(SrcDir),
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
    Conf = mad_utils:rebar_conf(Dir),
    Conf1 = mad_utils:script(Dir, Conf),
    SrcDir = mad_utils:src(Dir),
    Files = sort(erl_files(SrcDir)) ++ app_src_files(SrcDir),
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

validate_property({modules, _}, Modules) ->
    {modules, Modules};
validate_property(Else, _) ->
    Else.

compile_fun(SrcDir, IncDir, EbinDir, Opts) ->
    fun(F) ->
            code:add_path(EbinDir),
            F1 = filename:join(SrcDir, F),
            case is_app_src(F1) of
                false ->
                    Compiled = is_compiled(EbinDir, F1),
                    if Compiled =:= false ->
                            io:format("Compiling ~s~n", [F1]),
                            compile:file(F1, ?COMPILE_OPTS(IncDir, EbinDir) ++ Opts);
                       true ->
                            ok
                    end;
                true ->
                    %% add {modules, [Modules]} to .app file
                    AppFile = filename:join(EbinDir, app_src_to_app(F1)),
                    io:format("Writing ~s~n", [AppFile]),
                    BeamFiles = filelib:wildcard("*.beam", EbinDir),
                    Modules = [list_to_atom(filename:basename(X, ".beam"))
                               || X <- BeamFiles],
                    [Struct|_] = mad_utils:consult(F1),
                    {application, AppName, Props} = Struct,
                    Props1 = add_modules_property(Props),
                    Props2 = [validate_property(X, Modules) || X <- Props1],
                    Struct1 = {application, AppName, Props2},
                    file:write_file(AppFile, io_lib:format("~p.~n", [Struct1]))
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

erl_to_beam(EbinDir, Filename) ->
    filename:join(EbinDir, filename:basename(Filename, ".erl") ++ ".beam").

is_compiled(EbinDir, ErlFile) ->
    BeamFile = erl_to_beam(EbinDir, ErlFile),
    mad_utils:last_modified(BeamFile) > mad_utils:last_modified(ErlFile).

add_modules_property(Properties) ->
    case lists:keyfind(modules, 1, Properties) of
        {modules, _} ->
            Properties;
        _ ->
            Properties ++ [{modules, []}]
    end.

sort(Files) ->
    sort_by_priority(Files, [], [], []).

sort_by_priority([], High, Medium, Low) ->
    (High ++ Medium) ++ Low;
sort_by_priority([H|T], High, Medium, Low) ->
    {High1, Medium1, Low1} =
        case mad_utils:exec("sed", ["-n", "'/-callback/p'", H]) of
            [] ->
                {High, [H|Medium], Low};
            _ ->
                {[H|High], Medium, Low}
        end,
    {High2, Medium2, Low2} =
        case mad_utils:exec("sed", ["-n", "'/-compile/p'", H]) of
               [] ->
                {High1, Medium1, Low1};
               _ ->
                {High1 -- [H], Medium1 -- [H], [H|Low1]}
        end,
    sort_by_priority(T, High2, Medium2, Low2).
