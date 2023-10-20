SHELL := /bin/bash -i

help: 
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'



data-download: ## Download data.
data-download:
	sh scripts/preprocess/bair/create_bair_dataset.sh datasets/bair

docker-build: ## Build docker images.
docker-build: Dockerfile
	-( \
	docker build \
	--progress=plain \
	--build-arg UID_WORKER=$$UID \
	--build-arg GID_WORKER=`id -g` \
	-t videogpt:dev . \
	)

docker-run-i: ## Run docker container interactively
docker-run-i:
	-(\
	docker run \
	-it \
	--rm \
	--gpus all \
	videogpt:dev 'bash' \
	)

