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

    return(lists:any(fun({error,_}) -> true;
                                (_) -> false end,
           lists:flatten(
           lists:foldl(
                 fun ({Fun,Arg},[])  -> errors((profile()):Fun(Arg));
                     ({Fun,Arg},Err) -> errors(Invalid),
                                        { return, Err } end,
                 [], Valid)))).

atomize("static") -> 'static';
atomize("deploy") -> 'deploy';
atomize("app"++_) -> 'app';
atomize("dep")    -> 'deps';
atomize("deps")   -> 'deps';
atomize("cle"++_) -> 'clean';
atomize("com"++_) -> 'compile';
atomize("up")     -> 'up';
atomize("rel"++_) -> 'release';
atomize("bun"++_) -> 'release';
atomize("sta"++_) -> 'start';
atomize("sto"++_) -> 'stop';
atomize("att"++_) -> 'attach';
atomize("sh")     -> 'sh';
atomize("rep"++_) -> 'sh';
atomize("pla"++_) -> 'release';
atomize(Else)     -> Else.

profile()         -> application:get_env(mad,profile,mad_local).

errors([])        -> [];
errors(false)     -> [];
errors(true)      -> {error,unknown};
errors({error,L}) -> info("ERROR: ~tp~n",[L]), {error,L};
errors({ok,_})    -> info("OK~n",[]), [];
errors(X)         -> info("RETURN: ~tp~n",[X]), {error,X}.

return(true)      -> 1;
return(false)     -> 0;
return(X)         -> X.

info(Format)      -> io:format(lists:concat([Format,"\r"])).
info(Format,Args) -> io:format(lists:concat([Format,"\r"]),Args).

help(Reason,D)    -> help(io_lib:format("~s ~p", [Reason, D])).
help(Msg)         -> help().
help()            -> info("MAD Container Tool version ~s~n",[?VERSION]),
                     info("~n"),
                     info("    invoke = mad params~n"),
                     info("    params = [] | command [ options  ] params ~n"),
                     info("   command = app     | deps  | clean | compile | up~n"),
                     info("           | release [ beam  | ling  | script  | runc | depot ]~n"),
                     info("           | deploy  | start | stop  | attach  | sh ~n"),
                     return(false).
