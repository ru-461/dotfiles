FROM ubuntu:22.04

# Install the minimum required packages.
RUN apt-get update &&  \
  apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  curl \
  file \
  zsh  \
  sudo \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

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

# Set user data.
USER $USERNAME
WORKDIR /home/$USERNAME/

# Copy bootstrap script.
COPY --chown=$USERNAME:$USERNAME bootstrap.sh .

# Run bash.
CMD [ "/usr/bin/bash" ]
