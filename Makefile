SHELL := /bin/bash -i
PYTHON_VERSION := 3.7
PYTHON := python$(PYTHON_VERSION)

help: 
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'


conda-build-gpu: ## Create Python environement with conda for GPU.
conda-build-gpu:
	-( \
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& conda env list | grep '^VideoGptGpu\s' > /dev/null  \
	|| conda create --name VideoGptGpu python=$(PYTHON_VERSION) -y \
	&& conda activate VideoGptGpu \
	&& conda install --yes -c conda-forge cudatoolkit=11.0 cudnn \
	&& pip install -U pip \
	&& pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html \
	&& pip install . \
	)


conda-clean-gpu: ## Clean Python environement with conda for GPU.
conda-clean-gpu:
	-(\
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& conda env remove --name VideoGptGpu \
	)

conda-startlab-gpu: ## Startlab Python environement with conda for GPU.
conda-startlab-gpu:
	-(\
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& conda activate VideoGptGpu \
	&& jupyter lab --no-browser \
	)


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
	-v $(PWD):/home/worker/work \
	videogpt:dev 'bash' \
	)


docker-data-build: ## Build docker images for download data.
docker-data-build: data.Dockerfile
	-( \
	docker build \
	--progress=plain \
	--build-arg UID_WORKER=$$UID \
	--build-arg GID_WORKER=`id -g` \
	-t videogpt-data:dev -f data.Dockerfile . \
	)

docker-data-run: ## Run docker container for download data.  
docker-data-run:
	-(\
	docker run \
	-it \
	--rm \
	--gpus all \
	-v $(PWD):/home/worker/work \
	videogpt-data:dev entrypoints/download.bash \
	)
