default:
	echo "-define(VERSION,\"`git describe --tags`\")." > include/mad.hrl
	erlc -o ebin deps/ling/bc/*.erl || true
	./mad cle dep com str bun mad
