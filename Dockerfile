FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-devel

RUN apt --allow-insecure-repositories update -y
RUN apt-get install --allow-unauthenticated wget -y
RUN apt-get install emacs -y
RUN apt-get install git -y

# Create worker user.
ARG UID_WORKER=1000
ARG GID_WORKER=1000
RUN groupadd -g $GID_WORKER worker
RUN useradd \
    --uid $UID_WORKER \
    --gid $GID_WORKER \
    --create-home \
    --home-dir /home/worker \
    worker

# Switch to worker.
USER worker
WORKDIR /home/worker
COPY --chown=worker:worker ./notebooks ./notebooks
COPY --chown=worker:worker ./README.md ./README.md
COPY --chown=worker:worker ./requirements.txt ./requirements.txt
COPY --chown=worker:worker ./scripts ./scripts
COPY --chown=worker:worker ./setup.py ./setup.py
COPY --chown=worker:worker ./videogpt ./videogpt

# Checkout.
RUN which pip
RUN which python
RUN python --version
RUN conda env list

# Install python packages.
RUN pip install -U pip
RUN pip install git+https://github.com/wilson1yan/VideoGPT.git

