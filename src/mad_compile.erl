-module(mad_compile).

-export([deps/3]).
-export([app/2]).
-export([foreach/3]).

%% internal
-export([erl_files/1]).
-export([app_src_files/1]).
-export([is_app_src/1]).
-export([app_src_to_app/1]).
-export([erl_to_beam/2]).
-export([is_compiled/2]).

-define(COMPILE_OPTS(Inc, Ebin, Opts),
        [report, {i, Inc}, {outdir, Ebin}] ++ Opts).

-type directory() :: string().
-type filename() :: string().


%% compile dependencies
-spec deps(directory(), filename(), [mad_deps:dependency()]) -> ok.
deps(_, _, []) ->
    ok;
deps(Cwd, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    case get(Name) of
        compiled ->
            ok;
        _ ->
            dep(Cwd, ConfigFile, Name)
    end,
    deps(Cwd, ConfigFile, T).

%% compile a dependency
-spec dep(directory(), filename(), string()) -> ok.
dep(Cwd, ConfigFile, Name) ->
    %% check dependencies of the dependency
    DepPath = filename:join([Cwd, "deps", Name]),
    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_utils:script(DepConfigFile, Conf),
    deps(Cwd, ConfigFile, mad_utils:get_value(deps, Conf1, [])),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(DepPath, Conf1),
    code:add_paths(LibDirs),

    %% compile sub_dirs and add them to path
    SubDirs = mad_utils:sub_dirs(DepPath, ConfigFile, Conf),
    foreach(fun app/2, SubDirs, ConfigFile),

    SrcDir = mad_utils:src(DepPath),
    Files = sort(erl_files(SrcDir)) ++ app_src_files(SrcDir),
    case Files of
        [] ->
            ok;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),

            %% create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:add_path(EbinDir),

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            lists:foreach(compile_fun(IncDir, EbinDir, Opts), Files),
            put(Name, compiled),
            ok
    end.

-spec app(directory(), filename()) -> ok.
app(Dir, ConfigFile) ->
    ConfigFile1 = filename:join(Dir, ConfigFile),
    Conf = mad_utils:consult(ConfigFile1),
    Conf1 = mad_utils:script(ConfigFile1, Conf),
    SrcDir = mad_utils:src(Dir),
    Files = sort(erl_files(SrcDir)) ++ app_src_files(SrcDir),
    case Files of
        [] ->
            ok;
        Files ->
            IncDir = mad_utils:include(Dir),
            EbinDir = mad_utils:ebin(Dir),

            %% create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:add_path(EbinDir),

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            lists:foreach(compile_fun(IncDir, EbinDir, Opts), Files),
            ok
    end.

-spec validate_property({atom(), term()}, term()) -> {atom(), term()}.
validate_property({modules, _}, Modules) ->
    {modules, Modules};
validate_property(Else, _) ->
    Else.

-spec compile_fun(directory(), directory(), [compile:option()]) ->
                         fun((file:name()) -> ok).
compile_fun(IncDir, EbinDir, Opts) ->
    fun(File) ->
            case is_app_src(File) of
                false ->
                    Compiled = is_compiled(EbinDir, File),
                    if Compiled =:= false ->
                            io:format("Compiling ~s~n", [File]),
                            Opts1 = ?COMPILE_OPTS(IncDir, EbinDir, Opts),
                            compile:file(File, Opts1);
                       true ->
                            ok
                    end;
                true ->
                    %% add {modules, [Modules]} to .app file
                    AppFile = filename:join(EbinDir, app_src_to_app(File)),
                    io:format("Writing ~s~n", [AppFile]),
                    BeamFiles = filelib:wildcard("*.beam", EbinDir),
                    Modules = [list_to_atom(filename:basename(X, ".beam"))
                               || X <- BeamFiles],
                    [Struct|_] = mad_utils:consult(File),
                    {application, AppName, Props} = Struct,
                    Props1 = add_modules_property(Props),
                    Props2 = [validate_property(X, Modules) || X <- Props1],
                    Struct1 = {application, AppName, Props2},
                    file:write_file(AppFile, io_lib:format("~p.~n", [Struct1]))
            end
    end.

%% find all .erl files in Dir
-spec erl_files(directory()) -> [file:name()].
erl_files(Dir) ->
    filelib:fold_files(Dir, ".erl", true, fun(F, Acc) -> [F|Acc] end, []).

%% find all .app.src files in Dir
-spec app_src_files(directory()) -> [file:name()].
app_src_files(Dir) ->
    filelib:fold_files(Dir, ".app.src", true, fun(F, Acc) -> [F|Acc] end, []).

-spec is_app_src(file:name()) -> boolean().
is_app_src(Filename) ->
    Filename =/= filename:rootname(Filename, ".app.src").

-spec app_src_to_app(file:name()) -> file:name().
app_src_to_app(Filename) ->
    filename:basename(Filename, ".app.src") ++ ".app".

-spec erl_to_beam(directory(), file:name()) -> file:name().
erl_to_beam(EbinDir, Filename) ->
    filename:join(EbinDir, filename:basename(Filename, ".erl") ++ ".beam").

-spec is_compiled(directory(), file:name()) -> boolean().
is_compiled(EbinDir, ErlFile) ->
    BeamFile = erl_to_beam(EbinDir, ErlFile),
    mad_utils:last_modified(BeamFile) > mad_utils:last_modified(ErlFile).

-spec add_modules_property([{atom(), term()}]) -> [{atom(), term()}].
add_modules_property(Properties) ->
    case lists:keyfind(modules, 1, Properties) of
        {modules, _} ->
            Properties;
        _ ->
            Properties ++ [{modules, []}]
    end.

-spec sort([file:name()]) -> [file:name()].
sort(Files) ->
    sort_by_priority(Files, [], [], []).

-spec sort_by_priority([file:name()], [file:name()], [file:name()], [file:name()])
                      -> [file:name()].
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

-spec foreach(fun((directory(), filename()) -> ok), [filename()], filename()) ->
                     ok.
foreach(_, [], _) ->
    ok;
foreach(Fun, [Dir|T], ConfigFile) ->
    Fun(Dir, ConfigFile),
    foreach(Fun, T, ConfigFile).
