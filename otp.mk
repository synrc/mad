empty :=
ROOTS := deps .
space := $(empty) $(empty)
comma := $(empty),$(empty)
ERL_LIBS := $(subst $(space),:,$(ROOTS))

test: ct
compile: get-deps
get-deps compile clean:
	./mad $@
escript: compile
	./build
$(PLT_NAME):
	dialyzer -pa . -pa deps/*/ebin --build_plt --output_plt $(PLT_NAME) --apps $(APPS) || true
dialyze: compile $(PLT_NAME)
	dialyzer deps/*/ebin ebin --plt $(PLT_NAME) --no_native -Werror_handling -Wunderspecs -Wrace_conditions
ct: fetch-deps compile
	rebar ct skip_deps=true verbose=1

.PHONY: fetch-deps compile escript dialyze ct
