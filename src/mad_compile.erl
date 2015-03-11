-module(mad_compile).
-copyright('Sina Samavati').
-compile(export_all).

%% compile dependencies
deps(_, _, _, []) -> false;
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    Res = case get(Name) == compiled andalso get(mode) /= active  of
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
    io:format("==> ~p~n\r",[Name]),

    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_script:script(DepConfigFile, Conf, Name),
    Deps = mad_utils:get_value(deps, Conf1, []),
    DepsRes = deps(Cwd, Conf, ConfigFile, Deps),
    %io:format("DepsStatus: ~p~n",[DepsRes]),

    SrcDir = filename:join([mad_utils:src(DepPath)]),
    %io:format("DepPath ==> ~p~n\r",[DepPath]),

    Files = files(SrcDir,".yrl") ++ 
            files(SrcDir,".xrl") ++ 
            files(SrcDir,".erl") ++ % comment this to build with erlc/1
            files(SrcDir,".app.src"),

    case Files of
        [] -> false;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),
            LibDirs = mad_utils:get_value(lib_dirs, Conf, []),
            Includes = lists:flatten([
                [{i,filename:join([DepPath,L,D,include])} || D<-mad_utils:raw_deps(Deps) ] % for -include
             ++ [{i,filename:join([DepPath,L])}] || L <- LibDirs ]), % for -include_lib
            %io:format("DepPath ~p~n Includes: ~p~nLibDirs: ~p~n",[DepPath,Includes,LibDirs]),

            % create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:replace_path(Name,EbinDir),

            %erlc(DepPath), % comment this to build with files/2

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            FilesStatus = compile_files(Files,IncDir, EbinDir, Opts,Includes),
            DTLStatus = mad_dtl:compile(DepPath,Conf1),
            PortStatus = lists:any(fun(X)->X end,mad_port:compile(DepPath,Conf1)),
            %io:format("DTL Status: ~p~n",[DTLStatus]),
            %io:format("Port Status: ~p~n",[PortStatus]),
            %io:format("Files Status: ~p~n",[FilesStatus]),

            put(Name, compiled),
            DepsRes orelse FilesStatus orelse DTLStatus orelse PortStatus
    end.

compile_files([],_,_,_,_) -> false;
compile_files([File|Files],Inc,Bin,Opt,Deps) ->
    case (module(filetype(File))):compile(File,Inc,Bin,Opt,Deps) of
         true -> true;
         false -> compile_files(Files,Inc,Bin,Opt,Deps);
         _ -> io:format("Error: ~p~n",[{File}]) end.

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
    %io:format("Compile Apps: ~p~n",[Dirs]),
    case Dirs of
        [] -> mad_compile:dep(Cwd, Conf, ConfigFile, Cwd);
        Apps -> mad_compile:deps(Cwd, Conf, ConfigFile, Apps) end.

'compile-deps'(Cwd, ConfigFile, Conf) ->
    mad_compile:deps(Cwd, Conf, ConfigFile, mad_utils:get_value(deps, Conf, [])).

list(X) when is_atom(X) -> atom_to_list(X);
list(X) -> X.

erlc(DepPath) ->
    ErlFiles = filelib:wildcard(DepPath++"/src/**/*.erl"),
    io:format("Files: ~s~n\r",[[filename:basename(Erl)++" " ||Erl<-ErlFiles]]),
    {_,Status,X} = sh:run("erlc",["-o"++DepPath++"/ebin/","-I"++DepPath++"/include"]++
        ErlFiles,binary,filename:absname("."),[{"ERL_LIBS","apps:deps"}]),
    case Status == 0 of
         true -> skip;
         false -> io:format("Error: ~s~n\r",[binary_to_list(X)]) end.
