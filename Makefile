.PHONY: bin test install uninstall

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(shell dirname $(MKFILE_PATH))

install:
	@./scripts/install.sh
