-module(mad).
-copyright('Maxim Sokhatsky').
-include("mad.hrl").
-compile(export_all).
-export([main/1]).

main([])          -> halt(help());
main(Params)      ->

    % filter valid (atoms) from invalid (unparsed lists) commands
    { _Invalid, Valid } = lists:foldr(
        fun (X,{C,R}) when is_atom(X) -> {[],[{X,C}|R]};
                            (X,{C,R}) -> {[X|C],R} end,
             {[],[]}, lists:map(fun atomize/1, Params)),

    % return any error if exists on flattened fold of profile runs
    % of functions (commands) with arguments
    halt(return(
         lists:any(fun({error,X}) -> mad:info("~s~n",[X]), true; (_) -> false end,
         lists:flatten([
         lists:foldl(
         fun ({Fun,Arg},ErrAcc) ->
                  mad_hooks:run_hooks(pre, Fun),
                  Errors = errors((profile()):Fun(Arg)),
                  mad_hooks:run_hooks(post, Fun),
                  Errors ++ ErrAcc
         end, [], Valid)])))).

atomize("static") -> 'static';
atomize("deploy") -> 'deploy';
atomize("app"++_) -> 'app';
atomize("dep")    -> 'deps';
atomize("deps")   -> 'deps';
atomize("cle"++_) -> 'clean';
atomize("man")    -> 'man';
atomize("com"++_) -> 'compile';
atomize("eunit")  -> 'eunit';
atomize("up")     -> 'up';
atomize("get")    -> 'get';
atomize("rsa")    -> 'rsa';
atomize("ecc")    -> 'ecc';
atomize("rel"++_) -> 'release';
atomize("bun"++_) -> 'release';
atomize("sta"++_) -> 'start';
atomize("sto"++_) -> 'stop';
atomize("att"++_) -> 'attach';
atomize("sh")     -> 'sh';
atomize("dia"++_) -> 'dia';
atomize("rep"++_) -> 'sh';
atomize("pla"++_) -> 'resolve';
atomize("str"++_) -> 'strip';
atomize(Else)     -> Else.

profile()         -> application:get_env(mad,profile,mad_local).

errors([])            -> [];
errors(false)         -> [];
errors(true)          -> [{error,"Unknown."}];
errors({error,What})  -> info("ERROR~n"), [{error,What}];
errors({ok,_})        -> info("OK~n",[]), [].

return(true)      -> 1;
return(false)     -> 0.

host()            -> try {ok,H} = inet:gethostname(), H catch _:_ -> <<>> end.

info(Format)      -> io:format(lists:concat([Format,"\r"])).
info(Format,Args) -> io:format(lists:concat([Format,"\r"]),Args).

help(Reason,D)    -> help(io_lib:format("~s ~p", [Reason, D])).
help(_Msg)        -> help().
help()            -> info("MAD Manage Dependencies ~s~n",[?VERSION]),
                     info("~n"),
                     info("  spec = mad | mad list~n"),
                     info("  list =  [] | cmd [opt] list ~n"),
                     info("   cmd = app [nitro|zero] <name> | deps | clean | compile | strip~n"),
                     info("       | bundle [beam|script] <name> | man <html|check|groff> | repl~n"),
                     info("       | start | stop | attach | static <min> | get <repo> | up [name]~n"),
                     info("       | <rsa|ecc> [ new | ca | client key <name> | client pfx <name>~n"),
                     info("                   | client csr <subj> <name> | client cert <name>~n"),
                     info("                   | client revoke <name> | verify <name> <address>~n"),
                     info("                   | server key <name> | server csr <subj> <name>~n"),
                     info("                   | server cert <name> ]~n"),
                     return(false).
