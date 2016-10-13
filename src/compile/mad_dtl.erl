-module(mad_dtl).
-copyright('Sina Samavati').
-compile(export_all).

compile(Dir,Config) ->
    case mad_utils:get_value(erlydtl_opts, Config, []) of
        [] -> false;
         X -> O = validate_erlydtl_opts(Dir,X),
              case compile_erlydtl_files(O) of true -> true; 
                false -> case compile_erlydtl_naga_files({naga,view_dir},O) of 
                         true -> true; false -> compile_erlydtl_naga_files({naga_mail,mail_dir},O) end end end.

get_kv(K, Opts, Default) ->
    V = mad_utils:get_value(K, Opts, Default),
    KV = {K, V},
    {KV, Opts -- [KV]}.

file_to_beam(Bin, Filename) -> filename:join(Bin, filename:basename(Filename) ++ ".beam").

validate_erlydtl_opts(Cwd, Opts) ->
    DefaultDocRoot          = filename:join("priv", "templates"),
    {{_, DocRootDir}, Opts1}= get_kv(doc_root, Opts, DefaultDocRoot),
    {{_, OutDir1}, Opts2}   = get_kv(out_dir, Opts1, "ebin"),
    {CompilerOpts, Opts3}   = get_kv(compiler_options, Opts2, []),
    {SourceExt, Opts4}      = get_kv(source_ext, Opts3, ".dtl"),
    {ModuleExt, Opts5}      = get_kv(module_ext, Opts4, ""),

    DocRoot1 = {doc_root, filename:join(Cwd, DocRootDir)},
    OutDir2 = {out_dir, filename:join(Cwd, OutDir1)},
 
    [{cwd, Cwd},DocRoot1, OutDir2, CompilerOpts, SourceExt, ModuleExt|Opts5].


module_name(File, Ext, NewExt) ->
    list_to_atom(filename:basename(File, Ext) ++ NewExt).
module_name(File, ViewsOpts) ->
    {{_, Cwd}, _} = get_kv(cwd, ViewsOpts, ""),
    F = filename:split(File -- Cwd) -- ["/"],
    %mad:info("module_name File ~p~n",[F]),
    Name = mad_naga:view_module(F,ViewsOpts),
    list_to_atom(Name).

compile_erlydtl_files(Opts) ->

    {{_, DocRoot},   Opts1} = get_kv(doc_root,   Opts,  ""),
    {{_, SourceExt}, Opts2} = get_kv(source_ext, Opts1, ""),
    {{_, ModuleExt}, Opts3} = get_kv(module_ext, Opts2, ""),
    {{_, OutDir},        _} = get_kv(out_dir,    Opts3, ""),

    Files = filelib:fold_files(DocRoot, SourceExt++"$", true,
                               fun(F, Acc) -> [F|Acc] end, []),

    Compile = fun(F) ->
        ModuleName = module_name(F, SourceExt, ModuleExt),
        BeamFile = file_to_beam(OutDir, atom_to_list(ModuleName)),
        Compiled = mad_compile:is_compiled(BeamFile, F),
        case Compiled of false ->
             mad:info("DTL Compiling ~s~n", [F -- mad_utils:cwd()]),
             Res = erlydtl:compile(F, ModuleName, Opts3),
             file:change_time(BeamFile, calendar:local_time()),
             case Res of {error,Error} -> mad:info("Error: ~p~n",[Error]);
                                    OK -> OK end;
             true -> ok end
    end,

    lists:any(fun({error,_}) -> true; ({ok,_,_}) -> false; ({ok,_}) -> false; (ok) -> false end,[Compile(F) || F <- Files]).


compile_erlydtl_naga_files({App0,D}, Opts) ->

    {{_, Naga},    O1} = get_kv(App0,    Opts, []),    
    {{_, OutDir},  O2} = get_kv(out_dir, O1, "ebin"),
    {{_, Cwd},     O3} = get_kv(cwd,     O2, ""),

    Get = fun(X) -> 
            {{_, Val },  _} = get_kv(X, Naga, proplists:get_value(X, mad_naga:cfg_dtl())),
            case Val of true -> true; false-> false; [{_,_}|_]=E -> E; 
                Dir ->filename:join(Val) end end,

    case Get(enable) of true -> 
        NagaExt   = Get(extensions),
        Force     = Get(force),
        DocRoot   = filename:join(Cwd,Get(D)),
        TagDir    = filename:join(Cwd,Get(tag_dir)),
        FilterDir = filename:join(Cwd,Get(filter_dir)),
        HtmlTags  = filename:join(Cwd,Get(htmltags_dir)),
        CustomTags= filename:join(Cwd,Get(custom_tags)),
        AutoEscape= Get(auto_escape),
        App       = filename:basename(Cwd),
        OO = [ {cwd,Cwd},{app,App},{extensions, NagaExt},{view_dir, DocRoot}
              ,{htmltags_dir, HtmlTags},{tag_dir, TagDir}
              ,{filter_dir, FilterDir},{custom_tags, CustomTags}
              ],
        NagaOpts = [
         {cwd, Cwd},{doc_root, DocRoot},
         {app,App},{extensions, NagaExt},{out_dir, OutDir},
         {auto_escape, AutoEscape},
         {custom_filters_modules,mad_naga:modules(tag_dir, OO)++mad_naga:modules(filter_dir, OO)},
         {custom_tags_modules, mad_naga:modules(custom_tags, OO)},
         {custom_tags_dir, mad_naga:modules(htmltags_dir, OO)}],
      
        Files = mad_naga:find_files(DocRoot,NagaExt),
        
        Compile = fun(F) ->
            ModuleName = module_name(F, NagaOpts),
            BeamFile = file_to_beam(OutDir, atom_to_list(ModuleName)),
            Compiled = mad_compile:is_compiled(BeamFile, F),
            if  Compiled =:= false orelse Force ->
                 %mad:info("DTL options ~p",[NagaOpts]),
                 mad:info("DTL Compiling ~s --> ~s~n", [F -- mad_utils:cwd(), atom_to_list(ModuleName)]),
                 Res = erlydtl:compile(F, ModuleName, NagaOpts),
                 case Res of {error,Error} -> mad:info("Error: ~p~n",[Error]);
                                        OK -> OK end;
                 true -> ok end
        end,
        lists:any(fun({error,_}) -> true; ({ok,_}) -> false; (ok) -> false end,[Compile(F) || F <- Files]); 
        _ -> false end.

