-module(mad_compile).
-copyright('Sina Samavati').
-compile(export_all).

%% compile dependencies
deps(_, _, _, []) -> false;
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    Res = case get(Name) == compiled of
          true -> false;
          _    -> dep(Cwd, Conf, ConfigFile, Name) end,
    case Res of
         true  -> true;
         false -> deps(Cwd, Conf, ConfigFile, T) end.

%% compile a dependency
dep(Cwd, _Conf, ConfigFile, Name) ->

    %% check dependencies of the dependency
    DepsDir = filename:join([mad_utils:get_value(deps_dir, _Conf, ["deps"])]),
    DepPath = filename:join([Cwd, DepsDir, Name]),
    mad:info("==> ~p~n",[Name]),

    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_script:script(DepConfigFile, Conf, Name),
    Deps = mad_utils:get_value(deps, Conf1, []),
    DepsRes = deps(Cwd, Conf, ConfigFile, Deps),
    %mad:info("DepsStatus: ~p~n",[DepsRes]),

    SrcDir = filename:join([mad_utils:src(DepPath)]),
    %mad:info("DepPath ==> ~p~n",[DepPath]),

    AllFiles = files(SrcDir,".yrl") ++ 
               files(SrcDir,".xrl") ++ 
               files(SrcDir,".erl") ++ % comment this to build with erlc/1
               files(SrcDir,".app.src"),
    Files = case mad_utils:get_value(erl_first_files, Conf1, []) of
              []         -> AllFiles;
              FirstFiles ->
                FirstFiles1 = lists:map(fun (F) -> filename:join(SrcDir, F ++ ".erl") end, FirstFiles),
                FirstFiles1 ++ lists:filter(fun (F) -> lists:member(F, FirstFiles) == false end, AllFiles)
            end,

    case Files of
        [] -> false;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),
            LibDirs = mad_utils:get_value(lib_dirs, Conf, []),
            Includes = lists:flatten([
                [{i,filename:join([DepPath,L,D,include])} || D<-mad_utils:raw_deps(Deps) ] % for -include
             ++ [{i,filename:join([DepPath,L])}] || L <- LibDirs ]), % for -include_lib
            %mad:info("DepPath ~p~n Includes: ~p~nLibDirs: ~p~n",[DepPath,Includes,LibDirs]),

            % create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:replace_path(Name,EbinDir),

            %erlc(DepPath), % comment this to build with files/2

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            FilesStatus = compile_files(Files,IncDir, EbinDir, Opts,Includes),
            DTLStatus = mad_dtl:compile(DepPath,Conf1),
            PortStatus = lists:any(fun(X)->X end,mad_port:compile(DepPath,Conf1)),
            %mad:info("DTL Status: ~p~n",[DTLStatus]),
            %mad:info("Port Status: ~p~n",[PortStatus]),
            %mad:info("Files Status: ~p~n",[FilesStatus]),

            put(Name, compiled),
            DepsRes orelse FilesStatus orelse DTLStatus orelse PortStatus
    end.

compile_files([],_,_,_,_) -> false;
compile_files([File|Files],Inc,Bin,Opt,Deps) ->
    case (module(filetype(File))):compile(File,Inc,Bin,Opt,Deps) of
         true -> true;
         false -> compile_files(Files,Inc,Bin,Opt,Deps);
         _ -> mad:info("Error: ~p~n",[{File}]) end.

module("erl") -> mad_erl;
module("erl.src") -> mad_utils;
module("yrl") -> mad_yecc;
module("xrl") -> mad_leex;
module("app.src") -> mad_app;
module(_) -> mad_none.

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

erlc(DepPath) ->
    ErlFiles = filelib:wildcard(DepPath++"/src/**/*.erl"),
    mad:info("Files: ~s~n",[[filename:basename(Erl)++" " ||Erl<-ErlFiles]]),
    {_,Status,X} = sh:run("erlc",["-o"++DepPath++"/ebin/","-I"++DepPath++"/include"]++
        ErlFiles,binary,filename:absname("."),[{"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> skip;
         false -> mad:info("Error: ~s~n",[binary_to_list(X)]) end.
