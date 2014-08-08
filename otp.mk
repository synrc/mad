compile: get-deps
get-deps compile clean:
	rebar $@
escript: compile
	./build
ct: get-deps compile
	rebar ct skip_deps=true verbose=1

.PHONY: get-deps compile escript ct
