.PHONY: all compile clean build

all: clean compile build

clean:
	rm -rf ebin

erlc_verbose_0 = @echo " ERLC  " $(filter %.erl ,$(?F));
erlc_verbose = $(erlc_verbose_$(V))

define compile_erl
	$(erlc_verbose) erlc -v -o ebin/ $(1)
endef

compile: $(shell find src -type f -name \*.erl)
	@mkdir -p ebin/
	$(if $(strip $(filter %.erl ,$?)), \
		$(call compile_erl,$(filter %.erl %.core,$?)))

build:
	@./build
