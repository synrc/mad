-module(mad_compile).
-copyright('Sina Samavati').
-compile(export_all).

compile(Params) ->
    { Cwd, ConfigFile, Conf } = mad_utils:configs(),
    Res = case Params of
         [] -> mad_compile:'compile-deps'(Cwd, ConfigFile, Conf);
         __ -> mad_compile:deps(Cwd, Conf, ConfigFile, [Params])
    end,
    case bool(Res) of
         true -> {error,Params};
         false -> mad_compile:'compile-apps'(Cwd, ConfigFile, Conf) end.

deps(_, _, _, []) -> {ok,deps};
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_utils:name_and_repo(H),
    Res = case get(Name) == compiled of
          true -> {ok,[]};
          _    -> dep(Cwd, Conf, ConfigFile, Name) end,
    case bool(Res) of
         true  -> {error,Name};
         false -> deps(Cwd, Conf, ConfigFile, T) end.

bool({ok,_})    -> false;
bool({error,_}) -> true.

dep(Cwd, _Conf, ConfigFile, Name) ->

    DepsDir = filename:join([mad_utils:get_value(deps_dir, _Conf, ["deps"])]),
    DepPath = filename:join([Cwd, DepsDir, Name]),
    mad:info("==> ~p~n",[Name]),

    DepConfig = filename:join(DepPath, ConfigFile),
    Conf      = mad_utils:consult(DepConfig),
    Conf1     = mad_script:script(DepConfig, Conf, Name),
    Deps      = mad_utils:get_value(deps, Conf1, []),
    DepsRes   = bool(deps(Cwd, Conf, ConfigFile, Deps)),
    SrcDir    = filename:join([mad_utils:src(DepPath)]),
    PrivDir   = filename:join([mad_utils:priv(DepPath)]),
    PrivFiles = case application:get_env(mad,cubical,[]) of [] -> []; _ -> files(PrivDir,".ctt") end,

    AllFiles  = files(SrcDir,".yrl") ++
                files(SrcDir,".xrl") ++
                files(SrcDir,".erl"),

    AppSrcFiles = files(SrcDir,".app.src"),
    FirstFiles = [ filename:join([SrcDir,Y]) || Y <- mad_utils:get_value(erl_first_files, Conf1, []) ],
    Files = lists:filter(fun (F) -> lists:member(F, FirstFiles) == false end, AllFiles),

    case Files of
        [] -> {ok,Name};
        Files ->
            IncDir   = mad_utils:include(DepPath),
            EbinDir  = mad_utils:ebin(DepPath),
            LibDirs  = mad_utils:get_value(lib_dirs, Conf, []),
            Includes = lists:flatten([
                       [{i,filename:join([DepPath,L,D,include])} || D <- mad_utils:raw_deps(Deps) ]
                    ++ [{i,filename:join([DepPath,L])}] || L <- LibDirs ]),

            file:make_dir(EbinDir),
            code:replace_path(Name,EbinDir),

            PortStatus  = lists:any(fun(X)->X end,mad_port:compile(DepPath,Conf1)),
            Opts        = mad_utils:get_value(erl_opts, Conf1, []),
            DTLStatus   = mad_dtl:compile(DepPath,Conf1),
            FilesStatus = compile_files(FirstFiles++lists:sort(Files++PrivFiles)++AppSrcFiles,
                                        IncDir, EbinDir, Opts,Includes),

            put(Name, compiled),
            case (DepsRes orelse FilesStatus orelse DTLStatus orelse PortStatus)
                 andalso filelib:is_dir(Name)==false of
                 true -> {error,Name};
                 false -> {ok,Name} end end.

compile_files([],_,_,_,_) -> false;
compile_files([File|Files],Inc,Bin,Opt,Deps) ->
    case (module(filetype(File))):compile(File,Inc,Bin,Opt,Deps) of
         true -> io:format("Error: ~p~n",[[File,Inc,Bin,Opt,Deps]]), true;
         false -> compile_files(Files,Inc,Bin,Opt,Deps);
         X -> mad:info("Compilation Error: ~p~n",[{X,File}]), true end.

module("erl")      -> mad_erl;
module("ctt")      -> mad_cubical;
module("erl.src")  -> mad_utils;
module("yrl")      -> mad_yecc;
module("xrl")      -> mad_leex;
module("app.src")  -> mad_app;
module(_)          -> mad_none.

filetype(Path) -> string:join(tl(string:tokens(filename:basename(Path), ".")), ".").
files(Dir,Ext) -> filelib:fold_files(Dir, Ext, true, fun(F, Acc) -> [F|Acc] end, []).
is_compiled(BeamFile, File) -> mad_utils:last_modified(BeamFile) >= mad_utils:last_modified(File).

'compile-apps'(Cwd, ConfigFile, Conf) ->
    Dirs = mad_utils:sub_dirs(Cwd, ConfigFile, Conf),
    [put(D,0)||D<-Dirs],
    case Dirs of
           [] -> mad_compile:dep(Cwd,  Conf, ConfigFile, Cwd);
         Apps -> mad_compile:dep(Cwd,  Conf, ConfigFile, Cwd),
                 mad_compile:deps(Cwd, Conf, ConfigFile, Apps) end.

'compile-deps'(Cwd, ConfigFile, Conf) ->
    mad_compile:deps(Cwd, Conf, ConfigFile, mad_utils:get_value(deps, Conf, [])).

list(X) when is_atom(X) -> atom_to_list(X);
list(X) -> X.