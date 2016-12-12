-module(mad_tpl).
-copyright('Chan Sisowath').
-compile(export_all).

app(Params) -> 
    mad_repl:load(),
    Apps = ets:tab2list(filesystem),   
    Vars = decode_params(Params),
    case proplists:get_value(tpl, Vars) of
     undefined -> mad:help();
     TplName -> 
         AppName = proplists:get_value(name, Vars),
         mad:info("Name = ~p~n",[AppName]),
         mad:info("TplName = ~p~n",[TplName]),
         mad:info("Vars = ~p~n",[Vars]),
         %%FIXME: maybe add ~/.mad/templates/skel for personal template
         Skel = proplists:get_value("priv/" ++ TplName ++ ".skel", Apps),
         TemplateTerms = consult(Skel),
         Vars1 = lists:keyreplace(name, 1, Vars, {appid, AppName}),
         create(Apps, TemplateTerms, Vars1) end.

lib(_) -> ok.

decode_params(Params) ->
    decode_params(Params, []).

decode_params([],  Acc) -> Acc;
decode_params([H|T], Acc) -> 
    [K, V] = string:tokens(H, "="),
    decode_params(T, [{list_to_atom(K), V}|Acc]).
    
create(Files, FinalTemplate, VarsCtx) ->
    case lists:keyfind(variables, 1, FinalTemplate) of
        {variables, Vars} ->
            case parse_vars(Vars, dict:new()) of
                {error, _Entry} ->
                    Context0 = undefined;
                Context0 ->
                    ok
            end;
        false ->
            Context0 = dict:new()
    end,    
    %%Variables = lists:keyreplace(appid, 1, dict:to_list(Context0), {appid, Name}),
    Name = proplists:get_value(appid, VarsCtx),
    Variables = dict:to_list(Context0) ++ VarsCtx,
    Context = resolve_variables(Variables, Context0),
    Force = "1",
    %io:format("Context ~p~n", [[ begin {_, Y} = dict:find(X, Context), {X, Y} end|| X <- dict:fetch_keys(Context)]] ),
    execute_template(Files, FinalTemplate, none, Name, Context, Force, []),
    {ok,Name}.

% --------------------------------------------------------------------------------
% internal
% --------------------------------------------------------------------------------

-spec consult(string() | binary()) -> [term()].
consult(Source) ->
    SourceStr = to_str(Source),
    {ok, Tokens, _} = erl_scan:string(SourceStr),
    Forms = split_when(fun is_dot/1, Tokens),
    ParseFun = fun (Form) ->
                       case erl_parse:parse_exprs(Form) of
                       {ok, Expr} -> Expr;
                       E -> mad:info("Error mad_tpl ~p", [E]), E end 
               end,
    Parsed = lists:map(ParseFun, Forms),
    ExprsFun = fun(P) ->
                       {value, Value, _} = erl_eval:exprs(P, []),
                       Value
               end,
    lists:map(ExprsFun, Parsed).

-spec split_when(fun(), list()) -> list().
split_when(When, List) ->
    split_when(When, List, [[]]).

split_when(When, [], [[] | Results]) ->
    split_when(When, [], Results);
split_when(_When, [], Results) ->
    Reversed = lists:map(fun lists:reverse/1, Results),
    lists:reverse(Reversed);
split_when(When, [Head | Tail], [Current0 | Rest]) ->
    Current = [Head | Current0],
    Result = case When(Head) of
                 true ->
                     [[], Current | Rest];
                 false ->
                     [Current | Rest]
             end,
    split_when(When, Tail, Result).

-spec is_dot(tuple()) -> boolean().
is_dot({dot, _}) -> true;
is_dot(_) -> false.

-spec to_str(binary() | list() | atom()) -> string().
to_str(Arg) when is_binary(Arg) ->
    unicode:characters_to_list(Arg);
to_str(Arg) when is_atom(Arg) ->
    atom_to_list(Arg);
to_str(Arg) when is_integer(Arg) ->
    integer_to_list(Arg);
to_str(Arg) when is_list(Arg) ->
    Arg.



%%
%% Given a list of key value pairs, for each string value attempt to
%% render it using Dict as the context. Storing the result in Dict as Key.
%%
resolve_variables([], Dict) ->
    Dict;
resolve_variables([{Key, Value0} | Rest], Dict) when is_list(Value0) ->
    Value = render(list_to_binary(Value0), Dict),
    resolve_variables(Rest, dict:store(Key, Value, Dict));
resolve_variables([{Key, {list, Dicts}} | Rest], Dict) when is_list(Dicts) ->
    %% just un-tag it so mustache can use it
    resolve_variables(Rest, dict:store(Key, Dicts, Dict));
resolve_variables([_Pair | Rest], Dict) ->
    resolve_variables(Rest, Dict).

%%
%% Render a binary to a string, using erlydtl and the specified context
%%
render(Bin, Context) ->
    %% Be sure to escape any double-quotes before rendering...
    ReOpts = [global, {return, list}],
    Str0 = re:replace(Bin, "\\\\", "\\\\\\", ReOpts),
    Str1 = re:replace(Str0, "\"", "\\\\\"", ReOpts),
    mad_mustache:render(Str1, Context).

%% ===================================================================
%% Internal functions
%% ===================================================================




%%
%% Read the contents of a file from the appropriate source
%%
load_file(Files, _, Name) ->
    case lists:keyfind("priv/" ++ Name, 1, Files) of
        {_, Bin} -> Bin;
        _ -> ok
    end.

%%
%% Parse/validate variables out from the template definition
%%
parse_vars([], Dict) ->
    Dict;
parse_vars([{Key, Value} | Rest], Dict) when is_atom(Key) ->
    parse_vars(Rest, dict:store(Key, Value, Dict));
parse_vars([Other | _Rest], _Dict) ->
    {error, Other};
parse_vars(Other, _Dict) ->
    {error, Other}.

maybe_dict({Key, {list, Dicts}}) ->
    %% this is a 'list' element; a list of lists representing dicts
    {Key, {list, [dict:from_list(D) || D <- Dicts]}};
maybe_dict(Term) ->
    Term.

write_file(Output, Data, Force) ->
    %% determine if the target file already exists
    FileExists = filelib:is_regular(Output),

    %% perform the function if we're allowed,
    %% otherwise just process the next template
    case Force =:= "1" orelse FileExists =:= false of
        true ->
            ok = filelib:ensure_dir(Output),
            case {Force, FileExists} of
                {"1", true} ->
                    io:format("Writing ~s (forcibly overwriting)~n",
                             [Output]);
                _ ->
                    io:format("Writing ~s~n", [Output])
            end,
            case file:write_file(Output, Data) of
                ok ->
                    ok;
                {error, Reason} ->
                    io:format("Failed to write output file ~p: ~p\n",
                           [Output, Reason])
            end;
        false ->
            {error, exists}
    end.

execute_template(_Files, [], _TemplateType, _TemplateName,
                 _Context, _Force, ExistingFiles) ->
    case ExistingFiles of
        [] ->
            ok;
        _ ->
            Msg = lists:flatten([io_lib:format("\t* ~p~n", [F]) ||
                                    F <- lists:reverse(ExistingFiles)]),
            Help = "To force overwriting, specify -f/--force/force=1"
                " on the command line.\n",
            io:format("One or more files already exist on disk and "
                   "were not generated:~n~s~s", [Msg , Help])
    end;
execute_template(Files, [{template, "naga/src/project_sup.erl"=Input, Output} | Rest], TemplateType, 
                 TemplateName, Context, Force, ExistingFiles) ->
    File = load_file(Files, TemplateType, Input),
    OutputName = render(Output, Context),
    %io:format("template outputName ~p~n",[OutputName]),
    Name = list_to_binary(TemplateName),
    Bin = << "-module(", Name/binary ,"_sup).\n", File/binary >>,
    case write_file(OutputName, Bin, Force) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, exists} ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, [Output|ExistingFiles])
    end;
execute_template(Files, [{template, Input, Output} | Rest], TemplateType, 
                 TemplateName, Context, Force, ExistingFiles) ->
    File = load_file(Files, TemplateType, Input),
    OutputName = render(Output, Context),
    %io:format("template outputName ~p~n",[OutputName]),
    case write_file(OutputName, render(File, Context), Force) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, exists} ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, [Output|ExistingFiles])
    end;
execute_template(Files, [{file, Input, Output} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles) ->
    File = load_file(Files, TemplateType, Input),
    OutputName = render(Output, Context),    
    case write_file(OutputName, File, Force) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, exists} ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, [Output|ExistingFiles])
    end;
execute_template(Files, [{dir, InputName} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles) ->    
    Name = render(InputName, Context),
    case filelib:ensure_dir(filename:join(Name, "dummy")) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, Reason} ->
            io:format("Failed while processing template instruction "
                   "{dir, ~s}: ~p\n", [Name, Reason])
    end;
execute_template(Files, [{copy, Input, Output} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles) ->
    InputName = filename:join(filename:dirname(TemplateName), Input),    
    try cp_r([InputName ++ "/*"], Output) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles)
    catch _:_ ->
            io:format("Failed while processing template instruction "
                   "{copy, ~s, ~s}~n", [Input, Output])
    end;
execute_template(Files, [{chmod, Mod, File} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles)
  when is_integer(Mod) ->
    FileName = render(File, Context),
    case file:change_mode(FileName, Mod) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, Reason} ->
            io:format("Failed while processing template instruction "
                   "{chmod, ~b, ~s}: ~p~n", [Mod, FileName, Reason])
    end;
execute_template(Files, [{symlink, Existing, New} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles) ->
    case file:make_symlink(Existing, New) of
        ok ->
            execute_template(Files, Rest, TemplateType, TemplateName,
                             Context, Force, ExistingFiles);
        {error, Reason} ->
            io:format("Failed while processing template instruction "
                   "{symlink, ~s, ~s}: ~p~n", [Existing, New, Reason])
    end;
execute_template(Files, [{variables, _} | Rest], TemplateType,
                 TemplateName, Context, Force, ExistingFiles) ->
    execute_template(Files, Rest, TemplateType, TemplateName,
                     Context, Force, ExistingFiles);
execute_template(Files, [Other | Rest], TemplateType, TemplateName,
                 Context, Force, ExistingFiles) ->
    io:format("Skipping unknown template instruction: ~p\n", [Other]),
    execute_template(Files, Rest, TemplateType, TemplateName, Context,
                     Force, ExistingFiles).


-spec cp_r(list(string()), file:filename()) -> 'ok'.
cp_r([], _Dest) ->
    ok;
cp_r(Sources, Dest) ->
    case os:type() of
        {unix, _} ->
            EscSources = [escape_path(Src) || Src <- Sources],
            SourceStr = string:join(EscSources, " "),
            {done, 0, <<>>} = sh:run(["cp", "-R", SourceStr, Dest]),
            ok;
        {win32, _} -> 
            io:format("unsuported os."),
            ok
    end.

escape_path(Str) ->
    re:replace(Str, "([ ()?])", "\\\\&", [global, {return, list}]).