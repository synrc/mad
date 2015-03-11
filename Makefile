default: escript
escript:
	echo "-define(VERSION,\"`git rev-parse HEAD | head -c 6`\")." > include/mad.hrl
	./mad dep com bun mad
.PHONY: escript
