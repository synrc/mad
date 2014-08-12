compile: deps
deps compile clean:
	./mad $@
escript: compile
	./build

.PHONY: deps compile escript
