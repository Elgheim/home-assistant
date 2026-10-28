.PHONY: lint build check test-deploy test clean

lint:
	./tools/lint

build:
	./tools/build-config

check:
	./tools/check-config

test-deploy:
	./tools/test-deploy

test: lint check test-deploy

clean:
	rm -rf -- dist
