-module(mad_compile).
-copyright('Sina Samavati').
-export([deps/4,app/3,foreach/4]).
-export([erl_files/1,app_src_files/1,is_app_src/1,app_src_to_app/1,erl_to_beam/2,is_compiled/2]).
-define(COMPILE_OPTS(Inc, Ebin, Opts),
        [report, {i, Inc}, {outdir, Ebin}] ++ Opts).

-type directory() :: string().
-type filename() :: string().

%% compile dependencies
-spec deps(directory(), any(), filename(), [mad_deps:dependency()]) -> ok.
deps(_, _, _, []) ->
    ok;
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    case get(Name) of
        compiled ->
            ok;
        _ ->
            dep(Cwd, Conf, ConfigFile, Name)
    end,
    deps(Cwd, Conf, ConfigFile, T).

%% compile a dependency
-spec dep(directory(), any(), filename(), string()) -> ok.
dep(Cwd, _Conf, ConfigFile, Name) ->
    %% check dependencies of the dependency
    DepPath = filename:join([Cwd, "deps", Name]),
    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_utils:script(DepConfigFile, Conf),
    deps(Cwd, Conf, ConfigFile, mad_utils:get_value(deps, Conf1, [])),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(DepPath, Conf1),
    code:add_paths(LibDirs),

    %% compile sub_dirs and add them to path
    SubDirs = mad_utils:sub_dirs(DepPath, ConfigFile, Conf),
    foreach(fun app/3, SubDirs, Conf, ConfigFile),

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

-spec app(directory(), any(), filename()) -> ok.
app(Dir, Conf, ConfigFile) ->
    ConfigFile1 = filename:join(Dir, ConfigFile),
%    Conf = mad_utils:consult(ConfigFile1),
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
    end,
    ErlyDtlOpts = mad_utils:get_value(erlydtl_opts, Conf1, []),
    ErlyDtlOpts1 = validate_erlydtl_opts(Dir, ErlyDtlOpts),
    compile_erlydtl_files(ErlyDtlOpts1),
    ok.

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
                    BeamFile = erl_to_beam(EbinDir, File),
                    Compiled = is_compiled(BeamFile, File),
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
is_compiled(BeamFile, File) ->
    mad_utils:last_modified(BeamFile) > mad_utils:last_modified(File).

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
        case is_behaviour(H) of
            true ->
                {[H|High], Medium, Low};
            false ->
                {High, [H|Medium], Low}
        end,
    {High2, Medium2, Low2} =
        case mad_utils:exec("sed", ["-n", "'/-compile/p'", H]) of
               [] ->
                {High1, Medium1, Low1};
               _ ->
                {High1 -- [H], Medium1 -- [H], [H|Low1]}
        end,
    sort_by_priority(T, High2, Medium2, Low2).

-spec foreach(fun((directory(), filename()) -> ok), [filename()], any(), filename()) ->
                     ok.
foreach(_, [], _, _) ->
    ok;
foreach(Fun, [Dir|T], Config, ConfigFile) ->
    Fun(Dir, Config, ConfigFile),
    foreach(Fun, T, Config, ConfigFile).

-spec is_behaviour(file:name()) -> boolean().
is_behaviour(File) ->
    case filelib:is_file(File) of
        true ->
            [] =/= mad_utils:exec("sed", ["-n", "-e", "'/-callback/p'", "-e",
                                          "'/behaviour_info\\/1/p'", File]);
        _ ->
            false
    end.

get_kv(K, Opts, Default) ->
    V = mad_utils:get_value(K, Opts, Default),
    KV = {K, V},
    {KV, Opts -- [KV]}.

validate_erlydtl_opts(Cwd, Opts) ->
    DefaultDocRoot = filename:join("priv", "templates"),
    {DocRoot, Opts1} = get_kv(doc_root, Opts, DefaultDocRoot),
    {OutDir, Opts2} = get_kv(out_dir, Opts1, "ebin"),
    {CompilerOpts, Opts3} = get_kv(compiler_options, Opts2, []),
    {SourceExt, Opts4} = get_kv(source_ext, Opts3, ".dtl"),
    {ModuleExt, Opts5} = get_kv(module_ext, Opts4, ""),

    {_, DocRootDir} = DocRoot,
    DocRoot1 = {doc_root, filename:join(Cwd, DocRootDir)},
    {_, OutDir1} = OutDir,
    OutDir2 = {out_dir, filename:join(Cwd, OutDir1)},

    [DocRoot1, OutDir2, CompilerOpts, SourceExt, ModuleExt|Opts5].

module_name(File, Ext, NewExt) ->
    list_to_atom(filename:basename(File, Ext) ++ NewExt).

compile_erlydtl_files(Opts) ->
    {{_, DocRoot}, Opts1} = get_kv(doc_root, Opts, ""),
    {{_, SourceExt}, Opts2} = get_kv(source_ext, Opts1, ""),
    {{_, ModuleExt}, Opts3} = get_kv(module_ext, Opts2, ""),
    {{_, OutDir}, _} = get_kv(out_dir, Opts3, ""),

    Files = filelib:fold_files(DocRoot, SourceExt, true,
                               fun(F, Acc) -> [F|Acc] end, []),

    Compile = fun(F) ->
                      ModuleName = module_name(F, SourceExt, ModuleExt),
                      BeamFile = erl_to_beam(OutDir, atom_to_list(ModuleName)),
                      Compiled = is_compiled(BeamFile, F),
                      if Compiled =:= false ->
                              io:format("Compiling ~s~n", [F]),
                              erlydtl:compile(F, ModuleName, Opts3);
                         true ->
                              ok
                      end
              end,
    lists:foreach(Compile, Files).
