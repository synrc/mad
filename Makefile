default: escript
escript:
	echo "-define(VERSION,\"`git rev-parse HEAD | head -c 6`\")." > include/mad.hrl
	./mad cle dep com bun mad
.PHONY: escript
