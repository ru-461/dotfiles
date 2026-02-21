FROM ubuntu:22.04

# Install the minimum required packages.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  git \
  curl \
  file \
  zsh  \
  sudo \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Install chezmoi so README commands work inside the container.
RUN sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b /usr/local/bin && \
  chezmoi --version

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

# Prepare a shared workspace path before dropping privileges.
RUN mkdir -p /workspace/dotfiles && \
  chown -R $USERNAME:$GROUPNAME /workspace

# Set user data.
USER $USERNAME
WORKDIR /home/$USERNAME/

# Keep a full copy of the repository for local-source testing.
COPY --chown=$USERNAME:$USERNAME . /workspace/dotfiles

# Run bash.
CMD [ "/usr/bin/bash" ]
