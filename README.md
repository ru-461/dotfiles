# dotfiles

Any more dotfiles...
Configuration scripts that can be used anywhere.

## Features

- Manage dotfiles with [chezmoi](https://www.chezmoi.io/)
- Keep OS-specific files explicit (`karabiner` is only for macOS)
- Keep setup scripts (`install/*.sh`) as optional package/bootstrap helpers

## Support OS

- macOS (Only [Apple Silicon](https://support.apple.com/en-us/HT211814))
- Ubuntu (Only x64)
- Android (Only [Termux](https://github.com/termux) x64)

## Installation (Recommended)

Use the official chezmoi entrypoint:

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ru-461
```

## Daily Operations

```shell
chezmoi diff
chezmoi apply
chezmoi update
```

## Legacy Compatibility Entrypoints

The old scripts are still available as compatibility wrappers:

```shell
bash <(curl -fsSL https://raw.githubusercontent.com/ru-461/dotfiles/main/bootstrap.sh)
```

```shell
bash deploy.sh
```

Both wrappers delegate to chezmoi internally.

## age Setup (Foundation Only)

This repository prepares only the age foundation in this phase.
No encrypted target files are added yet.

1. Generate an age key pair:

```shell
chezmoi age keygen
```

2. Set your recipient in `~/.config/chezmoi/chezmoi.toml`:

```toml
[age]
recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

## Package Setup Scripts (Separate Responsibility)

Dotfile deployment is handled by chezmoi.
Package and OS provisioning scripts remain under `install/*.sh` and `functions/*.sh`.
Run them manually when needed.

## Notes on OS-specific Files

- `.config/karabiner/**` is deployed only on macOS.
- On Linux/WSL/Termux, karabiner files are excluded by `.chezmoiignore.tmpl`.

## Try Docker

Try dotfiles easily using Docker.
Build images in a locally cloned dotfiles repository.

```shell
docker build -t dotfiles --force-rm .
```

The latest Ubuntu-based container will be launched.

```shell
docker run -it --rm dotfiles
```

After entering the container, run:

```shell
chezmoi init --apply ru-461
```

Happy Hacking.
