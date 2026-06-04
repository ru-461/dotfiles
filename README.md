# dotfiles

Yet another dotfiles repository.
Configuration files you can carry anywhere.

## Features

- Manage dotfiles with [chezmoi](https://www.chezmoi.io/)
- Keep OS-specific files explicit (`karabiner` is only for macOS)
- Keep setup scripts (`install/*.sh`) as optional package/bootstrap helpers

## Supported OS

- macOS (Only [Apple Silicon](https://support.apple.com/en-us/HT211814))
- Ubuntu (Only x64)
- WSL (Ubuntu x64)
- Android (Only [Termux](https://github.com/termux) x64)

## Quick Start

Bootstrap a fresh machine with the official chezmoi entrypoint.
It installs chezmoi if missing, clones this repository, and applies every dotfile in one command:

```shell
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply ru-461
```

Reload your shell so the new configuration takes effect:

```shell
exec zsh
```

(Optional) Install development tools and packages via the bootstrap scripts:

```shell
bash "$(chezmoi source-path)/install/run.sh" --target auto
```

That's it. See [Daily Operations](#daily-operations) for editing and updating your dotfiles afterward.

## Daily Operations

```shell
chezmoi diff
chezmoi apply
chezmoi update
```

## age Encryption Setup

age encryption can be configured when needed, but is not used yet.
No encrypted files are tracked yet.

1. Generate an age key pair:

```shell
chezmoi age keygen
```

2. Set your recipient in `~/.config/chezmoi/chezmoi.toml`:

```toml
[age]
recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

## Package Setup Scripts

Dotfile deployment is handled by chezmoi.
Package and OS provisioning scripts remain under `install/*.sh` and `functions/*.sh`.
Use `install/run.sh` as the stable entrypoint.

```shell
bash "$(chezmoi source-path)/install/run.sh" --mode check
bash "$(chezmoi source-path)/install/run.sh" --target auto
```

Run only selected steps when needed:

```shell
bash "$(chezmoi source-path)/install/run.sh" --target auto --only zsh,brew,bundle
```

## Notes on OS-specific Files

- `.config/karabiner/**` is deployed only on macOS.
- On Linux/WSL/Termux, karabiner files are excluded by `.chezmoiignore.tmpl`.

## Try Docker

Try dotfiles in a reproducible Ubuntu container.
Build the image from a locally cloned dotfiles repository.

```shell
docker build -t dotfiles --force-rm .
```

### Option 1: Reproduce the current local repository (Recommended)

```shell
docker run -it --rm -v "$PWD":/workspace/dotfiles dotfiles
```

After entering the container, run:

```shell
chezmoi init --apply --source=/workspace/dotfiles
```

### Option 2: Reproduce from the remote `ru-461` repository

```shell
docker run -it --rm dotfiles /usr/bin/bash -lc "chezmoi init --apply ru-461 && exec /usr/bin/bash"
```

Happy Hacking.
