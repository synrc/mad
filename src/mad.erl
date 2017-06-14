-module(mad).
-copyright('Maxim Sokhatsky').
-include("mad.hrl").
-compile(export_all).
-export([main/1]).

main([])          -> help();
main(Params)      ->

    { Invalid, Valid } = lists:foldr(
                               fun (X,{C,R}) when is_atom(X) -> {[],[{X,C}|R]};
                                   (X,{C,R}) -> {[X|C],R} end,
                               {[],[]}, lists:map(fun atomize/1, Params)),

    return(
        lists:any(fun({error,_}) -> true; (_) -> false end,
            lists:flatten(
                lists:foldl(fun({Fun,Arg},[]) ->
                    mad_hooks:run_hooks(pre, Fun),
                    Errors = errors((profile()):Fun(Arg)),
                    mad_hooks:run_hooks(post, Fun),
                    Errors;
                ({_,_},Err) ->
                    errors(Invalid), {return,Err}
                end,
                [], Valid)
           )
        )
    ).

atomize("static") -> 'static';
atomize("deploy") -> 'deploy';
atomize("app"++_) -> 'app';
atomize("dep")    -> 'deps';
atomize("deps")   -> 'deps';
atomize("cle"++_) -> 'clean';
atomize("com"++_) -> 'compile';
atomize("eunit")  -> 'eunit';
atomize("up")     -> 'up';
atomize("rel"++_) -> 'release';
atomize("bun"++_) -> 'release';
atomize("sta"++_) -> 'start';
atomize("sto"++_) -> 'stop';
atomize("att"++_) -> 'attach';
atomize("sh")     -> 'sh';
atomize("rep"++_) -> 'sh';
atomize("pla"++_) -> 'resolve';
atomize(Else)     -> Else.

profile()         -> application:get_env(mad,profile,mad_local).

errors([])        -> [];
errors(false)     -> [];
errors(true)      -> {error,unknown};
errors({error,L}) -> info("ERROR: ~tp~n",[L]), [{error,L}];
errors({ok,_})    -> info("OK~n",[]), [];
errors(X)         -> info("RETURN: ~tp~n",[X]), [{error,X}].

return(true)      -> 1;
return(false)     -> 0;
return(X)         -> X.

host()            -> try {ok,H} = inet:gethostname(), H catch _:_ -> <<>> end.

info(Format)      -> io:format(lists:concat([Format,"\r"])).
info(Format,Args) -> io:format(lists:concat([Format,"\r"]),Args).

help(Reason,D)    -> help(io_lib:format("~s ~p", [Reason, D])).
help(_Msg)        -> help().
help()            -> info("MAD Container Tool version ~s~n",[?VERSION]),
                     info("~n"),
                     info("    invoke = mad params~n"),
                     info("    params = [] | command [ options  ] params ~n"),
                     info("   command = app     | deps  | clean | compile | up | eunit~n"),
                     info("           | release [ beam  | ling  | script  | runc | depot ]~n"),
                     info("           | deploy  | start | stop  | attach  | sh | static [ <watch|min> ] ~n"),
                     return(false).
