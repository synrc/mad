-module(mad_start).
-compile(export_all).

main(Params) ->
    sh:run("run_erl",9).

%	RUN_ERL_LOG_GENERATIONS=1000 RUN_ERL_LOG_MAXSIZE=20000000 \
%	ERL_LIBS=$(ERL_LIBS) run_erl -daemon $(RUN_DIR)/ $(LOG_DIR)/ "exec $(MAKE) console"
