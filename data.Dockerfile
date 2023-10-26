FROM tensorflow/tensorflow:1.15.5-gpu
#RUN apt-get install emacs -y

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
WORKDIR /home/worker/work
COPY --chown=worker:worker ./notebooks ./notebooks
COPY --chown=worker:worker ./README.md ./README.md
COPY --chown=worker:worker ./requirements.txt ./requirements.txt
COPY --chown=worker:worker ./scripts ./scripts
COPY --chown=worker:worker ./setup.py ./setup.py
COPY --chown=worker:worker ./videogpt ./videogpt

# Config bash
RUN echo "export PATH=$PATH:/home/worker/.local/bin" >> ~/.bashrc

# Checkout.
RUN which pip
RUN which python
RUN python --version

# Install python packages.
RUN pip install -U pip
RUN pip install tqdm
RUN pip install requests
RUN pip install h5py
RUN pip install Pillow
# RUN pip install av
# RUN pip install gradio
# RUN pip install moviepy
RUN pip install imageio
# RUN pip install gdown

