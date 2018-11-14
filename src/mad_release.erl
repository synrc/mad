-module(mad_release).
-compile(export_all).

release(["beam",N])      -> mad_systools:beam_release(N);
release(["script",N])    -> mad_escript:main(N);
release(["beam"])        -> release(["beam",  "sample"]);
release(["script"])      -> release(["script","sample"]);
release([])              -> release(["script"]);
release([X])             -> release(["script",X]).

