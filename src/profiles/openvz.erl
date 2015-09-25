-module(openvz).
-compile(export_all).

deps(Params)      -> mad_deps:deps(Params).
compile(Params)   -> mad_compile:compile(Params).
app(Params)       -> mad_static:app(Params).
clean(Params)     -> mad_vz:clean(Params).
start(Params)     -> mad_vz:start(Params).
attach(Params)    -> mad_vz:attach(Params).
stop(Params)      -> mad_vz:stop(Params).
release(Params)   -> mad_release:release(Params).
sh(Params)        -> {error,'N/A'}.
up(Params)        -> mad_deps:up(Params).
