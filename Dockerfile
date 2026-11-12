# syntax=docker/dockerfile:1

# Reproducible Ubuntu environment for testing dotfiles with chezmoi and Linuxbrew.
FROM ubuntu:22.04

# Avoid interactive apt prompts and ensure UTF-8 locale.
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Non-root user for Brew installation and install script testing.
ARG USERNAME=docker
ARG GROUPNAME=docker
ARG UID=1000
ARG GID=1000
# chezmoi release to install (without the leading "v").
ARG CHEZMOI_VERSION=2.74.1

# Keep downloaded packages so the apt cache mounts below are reused across builds.
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# Install dependencies, chezmoi, and create the test user in a single layer.
# Apt cache mounts speed up rebuilds when only COPY changes.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      file \
      git \
      locales \
      sudo \
      zsh \
    && locale-gen ja_JP.UTF-8 \
    && sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b /usr/local/bin -t "v${CHEZMOI_VERSION}" \
    && chezmoi --version \
    && groupadd -g "${GID}" "${GROUPNAME}" \
    && useradd -m -s /bin/bash -u "${UID}" -g "${GID}" -G sudo "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && visudo -cf "/etc/sudoers.d/${USERNAME}" \
    && mkdir -p /workspace/dotfiles \
    && chown -R "${USERNAME}:${GROUPNAME}" /workspace

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Bake in a copy of the repo for local-source testing (see README Option 1/2).
COPY --chown=${USERNAME}:${GROUPNAME} . /workspace/dotfiles

CMD ["/usr/bin/bash"]
