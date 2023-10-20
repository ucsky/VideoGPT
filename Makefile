SHELL := /bin/bash -i

help: 
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'


conda-install: ## Install Conda env.
conda-install:
	-(. $${HOME}/activate/miniconda3 \
	&& (conda env list | egrep '^VideoGPT\s+/' && conda activate VideoGPT || conda create --name VideoGPT python=3.9 -y) \
	&& conda install --yes -c conda-forge cudatoolkit=11.7 cudnn \
	&& pip install -U pip \
	&& pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html \
	&& pip install git+https://github.com/wilson1yan/VideoGPT.git \
	)

conda-delete: ## Delete conda env.
conda-delete:
	-(. $${HOME}/activate/miniconda3 \
	&& conda env remove --name VideoGPT \
	)	

data-download: ## Download data.
data-download:
	sh scripts/preprocess/bair/create_bair_dataset.sh datasets/bair

