-module(mad_local).
-include("api.hrl").
-export(?MAD).

compile(Params)   -> mad_compile:compile(Params).
app(Params)       -> mad_static:app(Params).
static(Params)    -> mad_static:main([],Params).
release(Params)   -> mad_release:release(Params).
strip(Params)     -> mad_release:strip(Params).
resolve(Params)   -> mad_release:resolve(Params).
clean(Params)     -> mad_run:clean(Params).
start(Params)     -> mad_run:start(Params).
attach(Params)    -> mad_run:attach(Params).
stop(Params)      -> mad_run:stop(Params).
get(Params)       -> mad_git:get_repo(Params).
deps(Params)      -> mad_git:deps(Params).
up(Params)        -> mad_git:up(Params).
fetch(Params)     -> mad_git:fetch(Params).
eunit(Params)     -> mad_eunit:main_test(Params).
sh(Params)        -> mad_repl:sh(Params).
ez(Params)        -> mad_ez:main(Params).