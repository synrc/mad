-define(MAD,[compile/1,app/1,get/1,man/1,dia/1,release/1,resolve/1,clean/1,
             start/1,attach/1,stop/1,sh/1,deps/1,up/1,fetch/1,rsa/1,ecc/1,
             static/1,eunit/1,strip/1,scaffolding/1]).

-type return() :: [] | true | false | {ok,any()} | {error,any()}.

-spec compile(list(string())) -> return().
-spec app(list(string())) -> return().
-spec get(list(string())) -> return().
-spec release(list(string())) -> return().
-spec resolve(list(string())) -> return().
-spec clean(list(string())) -> return().
-spec start(list(string())) -> return().
-spec attach(list(string())) -> return().
-spec stop(list(string())) -> return().
-spec sh(list(string())) -> return().
-spec deps(list(string())) -> return().
-spec up(list(string())) -> return().
-spec man(list(string())) -> return().
-spec rsa(list(string())) -> return().
-spec ecc(list(string())) -> return().
-spec dia(list(string())) -> return().
-spec fetch(list(string())) -> return().
-spec static(list(string())) -> return().
-spec eunit(list(string())) -> return().
-spec strip(list(string())) -> return().
-spec scaffolding(list(string())) -> return().
