FROM ubuntu:16.04

# Install dependencies
RUN apt-get update --yes && apt-get upgrade --yes
RUN DEBIAN_FRONTEND=noninteractive apt-get install git \
libcairo2-dev libjpeg8-dev libpango1.0-dev libgif-dev libpng-dev build-essential g++ \
ffmpeg curl \
redis-server --yes

# Non-privileged user
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN useradd -m audiogram
USER audiogram
WORKDIR /home/audiogram

ENV NVM_DIR /home/audiogram/.nvm
ENV NODE_VERSION 6.14.4


RUN mkdir -p $NVM_DIR && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Clone repo
RUN git clone https://github.com/nypublicradio/audiogram.git
WORKDIR /home/audiogram/audiogram

# Install dependencies
RUN . /home/audiogram/.nvm/nvm.sh && npm install
