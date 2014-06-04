-module(mad_compile).
-copyright('Sina Samavati').
-compile(export_all).
-define(COMPILE_OPTS(Inc, Ebin, Opts), [report, {i, Inc}, {outdir, Ebin}] ++ Opts).

-type directory() :: string().
-type filename() :: string().

%% compile dependencies
-spec deps(directory(), any(), filename(), [mad_deps:dependency()]) -> ok.
deps(_, _, _, []) -> ok;
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    case get(Name) == compiled andalso get(mode) /= active  of
        true -> ok;
        _ -> dep(Cwd, Conf, ConfigFile, Name) end,
    deps(Cwd, Conf, ConfigFile, T).

%% compile a dependency
-spec dep(directory(), any(), filename(), string()) -> ok.
dep(Cwd, _Conf, ConfigFile, Name) ->
    io:format("==> ~p~n",[Name]),
    %% check dependencies of the dependency
    DepsDir = filename:join([mad_utils:get_value(deps_dir, _Conf, ["deps"])]),
    DepPath = filename:join([Cwd, DepsDir, Name]),
    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_utils:script(DepConfigFile, Conf),
    deps(Cwd, Conf, ConfigFile, mad_utils:get_value(deps, Conf1, [])),

    %% add lib_dirs to path
    LibDirs = mad_utils:lib_dirs(DepPath, Conf1),
    code:add_paths(LibDirs),

    SrcDir = filename:join([mad_utils:src(DepPath)]),
    Files = yrl_files(SrcDir) ++ erl_files(SrcDir) ++ app_src_files(SrcDir),

    case Files of
        [] -> ok;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),

            %% create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:add_path(EbinDir),

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            lists:foreach(compile_fun(IncDir, EbinDir, Opts), Files),

            dtl(DepPath,Conf1),

            put(Name, compiled),
            ok
    end.


dtl(Dir,Config) ->
    case mad_utils:get_value(erlydtl_opts, Config, []) of
        [] -> skip;
         X -> compile_erlydtl_files(validate_erlydtl_opts(Dir,X)) end.


-spec validate_property({atom(), term()}, term()) -> {atom(), term()}.
validate_property({modules, _}, Modules) -> {modules, Modules};
validate_property(Else, _) -> Else.

-spec compile_fun(directory(), directory(), [compile:option()]) ->
    fun((file:name(),string(),string(),list(tuple(any(),any())),string()) -> ok).
compile_fun(Inc,Bin,Opt) -> fun(File) -> compile(File,Inc,Bin,Opt,filetype(File)) end.

filetype(Path) -> "." ++ string:join(tl(string:tokens(filename:basename(Path), ".")), ".").

compile(File,Inc,Bin,Opt,".yrl") ->
    ErlFile = yrl_to_erl(File),
    Compiled = is_compiled(ErlFile,File),
    if Compiled == false ->
        yecc:file(File),
        compile(ErlFile,Inc,Bin,Opt,".erl"); true -> ok end;
compile(File,Inc,Bin,Opt,".erl") ->
    BeamFile = erl_to_beam(Bin, File),
    Compiled = is_compiled(BeamFile, File),
    if  Compiled =:= false ->
        io:format("Compiling ~s~n", [File]),
        Opts1 = ?COMPILE_OPTS(Inc, Bin, Opt),
        compile:file(File, Opts1),
        ok;
    true -> ok end;
compile(File,_Inc,Bin,_Opt,".app.src") ->
    AppFile = filename:join(Bin, app_src_to_app(File)),
    Compiled = is_compiled(AppFile, File),
    if  Compiled =:= false ->
    io:format("Writing ~s~n", [AppFile]),
    BeamFiles = filelib:wildcard("*.beam", Bin),
    Modules = [list_to_atom(filename:basename(X, ".beam")) || X <- BeamFiles],
    [Struct|_] = mad_utils:consult(File),
    {application, AppName, Props} = Struct,
    Props1 = add_modules_property(Props),
    Props2 = [validate_property(X, Modules) || X <- Props1],
    Struct1 = {application, AppName, Props2},
    file:write_file(AppFile, io_lib:format("~p.~n", [Struct1])),
    ok;
    true -> ok end;
compile(File,_Inc,_Bin,_Opt,_) ->
    io:format("Unknown file type: ~p~n",[File]).

-spec erl_files(directory()) -> [file:name()].
-spec app_src_files(directory()) -> [file:name()].
-spec app_src_to_app(file:name()) -> file:name().
-spec erl_to_beam(directory(), file:name()) -> file:name().
-spec is_compiled(directory(), file:name()) -> boolean().
-spec add_modules_property([{atom(), term()}]) -> [{atom(), term()}].

erl_files(Dir) -> filelib:fold_files(Dir, ".erl", true, fun(F, Acc) -> [F|Acc] end, []).
yrl_files(Dir) -> filelib:fold_files(Dir, ".yrl", true, fun(F, Acc) -> [F|Acc] end, []).
app_src_files(Dir) -> filelib:fold_files(Dir, ".app.src", false, fun(F, Acc) -> [F|Acc] end, []).

app_src_to_app(Filename) -> filename:basename(Filename, ".app.src") ++ ".app".
yrl_to_erl(Filename) -> filename:join(filename:dirname(Filename),filename:basename(Filename, ".yrl")) ++ ".erl".
erl_to_beam(Bin, Filename) -> filename:join(Bin, filename:basename(Filename, ".erl") ++ ".beam").
is_compiled(BeamFile, File) -> mad_utils:last_modified(BeamFile) > mad_utils:last_modified(File).
add_modules_property(Properties) ->
    case lists:keyfind(modules, 1, Properties) of
        {modules, _} -> Properties;
        _ -> Properties ++ [{modules, []}] end.

-spec foreach(fun((directory(), filename()) -> ok), [filename()], any(), filename()) -> ok.
foreach(_, [], _, _) -> ok;
foreach(Fun, [Dir|T], Config, ConfigFile) ->
    Fun(Dir, Config, ConfigFile),
    foreach(Fun, T, Config, ConfigFile).

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

    {{_, DocRoot},   Opts1} = get_kv(doc_root,   Opts,  ""),
    {{_, SourceExt}, Opts2} = get_kv(source_ext, Opts1, ""),
    {{_, ModuleExt}, Opts3} = get_kv(module_ext, Opts2, ""),
    {{_, OutDir},        _} = get_kv(out_dir,    Opts3, ""),

    Files = filelib:fold_files(DocRoot, SourceExt, true,
                               fun(F, Acc) -> [F|Acc] end, []),

    Compile = fun(F) ->
        ModuleName = module_name(F, SourceExt, ModuleExt),
        BeamFile = erl_to_beam(OutDir, atom_to_list(ModuleName)),
        Compiled = is_compiled(BeamFile, F),
        if  Compiled =:= false ->
            io:format("DTL Compiling ~s~n", [F]),
            erlydtl:compile(F, ModuleName, Opts3);
        true -> ok end
    end,

    lists:foreach(Compile, Files).
