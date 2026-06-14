.PHONY: help run build deploy publish publish-one set-meta hash-show hash-reset hash-reset-all

# Helper macro to check for required command-line variables
require-var = $(if $(strip $($1)),,$(error Missing required variable: Please provide '$1=...'))

## help: Show available commands
help:
	@echo "Available commands:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' |  sed -e 's/^/ /'

## install: install npm package and make project ready to work
install:
	npm install
## run: run locally on localhost:4321 and check your changes
run:
	npm run dev

## build: output repo directory and commit changes based on env variables
build:
	@bash ./bin/build.sh

## deploy: built content to your remote repo
deploy:
	@bash ./bin/deploy.sh

## publish: Scan all posts and process only changed ones
publish:
	npm run crosspost

## publish-one: Force process one specific post (requires slug=...)
publish-one:
	$(call require-var,slug)
	npm run crosspost -- --slug $(slug)

## set-meta: Set frontmatter value (requires slug=..., key=..., value=...)
set-meta:
	$(call require-var,slug)
	$(call require-var,key)
	$(call require-var,value)
	npm run crosspost -- --set $(slug) $(key)=$(value)

## hash-show: See all hashes and change status
hash-show:
	npm run crosspost -- --hash-show

## hash-reset: Force reprocess one post next run (requires slug=...)
hash-reset:
	$(call require-var,slug)
	npm run crosspost -- --hash-reset $(slug)

## hash-reset-all: Force reprocess everything next run
hash-reset-all:
	npm run crosspost -- --hash-reset-all