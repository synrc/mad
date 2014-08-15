compile: deps
deps compile:
	./mad $@
escript: compile
	./mad dep com bun mad
.PHONY: deps compile escript
