FROM ubuntu:20.04

# Install the minimum required packages.
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    sudo \
    ca-certificates

RUN adduser --disabled-password \
    --gecos '' docker

RUN adduser docker sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
    /etc/sudoers

USER docker

WORKDIR /home/docker

# Copy bootstrap script
COPY bootstrap.sh .

CMD [ "/usr/bin/bash" ]