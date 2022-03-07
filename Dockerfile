FROM ubuntu:20.04

# Install the minimum required packages.
RUN apt-get update &&  \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    curl \
    file \
    zsh  \
    sudo

# Add user for testing Brew installation.
ARG USERNAME=docker
ARG GROUPNAME=docker
ARG UID=1000
ARG GID=1000
ARG PASSWORD=docker

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo $USERNAME:$PASSWORD | chpasswd && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN chmod +x bootstrap.sh

USER $USERNAME

WORKDIR /home/$USERNAME/

# Copy bootstrap script
COPY bootstrap.sh .

CMD [ "/usr/bin/bash" ]