all: init

.PHONY: init
init:
	git config core.hooksPath .hooks
