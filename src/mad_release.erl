-module(mad_release).
-compile(export_all).

release([])              -> release(["script"]);
release(["depot"])       -> release(["depot", "sample"]);
release(["beam"])        -> release(["beam",  "sample"]);
release(["ling"])        -> release(["ling",  "sample"]);
release(["script"])      -> release(["script","sample"]);
release(["ling",N])      -> mad_ling:ling(N);
release(["script",N])    -> mad_escript:main(N);
release(["beam",N])      -> mad_systools:beam_release(N);
release([X])             -> release(["script",X]).
