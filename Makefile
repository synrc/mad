default:
	echo "-define(VERSION,\"`git rev-parse HEAD | head -c 6`\")." > include/mad.hrl
	mkdir -p ebin
	erlc -o ebin deps/ling/bc/*.erl || true
	./mad cle dep com bun mad
