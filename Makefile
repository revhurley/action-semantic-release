
IMAGE_NAME:=action-semantic-release

lint: ## Runs hadoint against application dockerfile
	@docker run --rm -v "$(PWD):/data" -w "/data" hadolint/hadolint hadolint Dockerfile

build: ## Builds the docker image
	@docker build . -t $(IMAGE_NAME)

run: build ## Runs the container
	@docker run -it --rm $(IMAGE_NAME) -v

test: build ## Runs a test in the image
	@docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${PWD}:/test zemanlx/container-structure-test:v1.8.0-alpine \
    test \
    --image $(IMAGE_NAME) \
    --config test/structure-tests.yaml

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.DEFAULT_GOAL := help
.PHONY: lint build test help
