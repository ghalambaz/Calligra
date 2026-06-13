.PHONY: build run

run:
	npm run dev

build:
	@bash ./bin/build.sh

deploy:
	@bash ./bin/deploy.sh

help:
	@echo "make run   - run on localhost and check your changes"
	@echo "make build  - build output repo directory and commit changes"
	@echo "make deploy  - deploy built content to your remote repo"