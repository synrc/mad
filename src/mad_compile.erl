-module(mad_compile).
-copyright('Sina Samavati').
-compile(export_all).

%% compile dependencies
deps(_, _, _, []) -> ok;
deps(Cwd, Conf, ConfigFile, [H|T]) ->
    {Name, _} = mad_deps:name_and_repo(H),
    case get(Name) == compiled andalso get(mode) /= active  of
        true -> ok;
        _ -> dep(Cwd, Conf, ConfigFile, Name) end,
    deps(Cwd, Conf, ConfigFile, T).

%% compile a dependency
dep(Cwd, _Conf, ConfigFile, Name) ->
    %% check dependencies of the dependency
    DepsDir = filename:join([mad_utils:get_value(deps_dir, _Conf, ["deps"])]),
    DepPath = filename:join([Cwd, DepsDir, Name]),
    io:format("==> ~p~n\r",[Name]),

    DepConfigFile = filename:join(DepPath, ConfigFile),
    Conf = mad_utils:consult(DepConfigFile),
    Conf1 = mad_script:script(DepConfigFile, Conf, Name),
    deps(Cwd, Conf, ConfigFile, mad_utils:get_value(deps, Conf1, [])),

    SrcDir = filename:join([mad_utils:src(DepPath)]),

    Files = files(SrcDir,".yrl") ++ 
            files(SrcDir,".erl") ++ % comment this to build with erlc/1
            files(SrcDir,".app.src"),

    case Files of
        [] -> ok;
        Files ->
            IncDir = mad_utils:include(DepPath),
            EbinDir = mad_utils:ebin(DepPath),

            %% create EbinDir and add it to code path
            file:make_dir(EbinDir),
            code:replace_path(Name,EbinDir),

            %erlc(DepPath), % comment this to build with files/2

            Opts = mad_utils:get_value(erl_opts, Conf1, []),
            lists:foreach(compile_fun(IncDir, EbinDir, Opts), Files),

            mad_dtl:compile(DepPath,Conf1),
            mad_port:compile(DepPath,Conf1),

            put(Name, compiled),
            ok
    end.

compile_fun(Inc,Bin,Opt) -> fun(File) -> (module(filetype(File))):compile(File,Inc,Bin,Opt) end.

module("erl") -> mad_erl;
module("erl.src") -> mad_utils;
module("yrl") -> mad_yecc;
module("app.src") -> mad_app;
module(_) -> mad_script.

filetype(Path) -> string:join(tl(string:tokens(filename:basename(Path), ".")), ".").
files(Dir,Ext) -> filelib:fold_files(Dir, Ext, true, fun(F, Acc) -> [F|Acc] end, []).
is_compiled(BeamFile, File) -> mad_utils:last_modified(BeamFile) >= mad_utils:last_modified(File).

'compile-apps'(Cwd, ConfigFile, Conf) ->
    Dirs = mad_utils:sub_dirs(Cwd, ConfigFile, Conf),
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
