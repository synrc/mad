default:
	echo "-define(VERSION,\"`git rev-parse HEAD | head -c 6`\")." > include/mad.hrl
	erlc -o ebin deps/ling/bc/*.erl || true
	./mad cle dep com rel script mad
