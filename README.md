# dotfiles

Yet another dotfiles repository.
Configuration files you can carry anywhere.

## Features

- Manage dotfiles with [chezmoi](https://www.chezmoi.io/)
- Keep OS-specific files explicit (`karabiner` is only for macOS)
- Keep setup scripts (`install/*.sh`) as optional package/bootstrap helpers

## Supported OS

- macOS (only [Apple Silicon](https://support.apple.com/en-us/HT211814))
- Ubuntu (only x64)
- WSL (Ubuntu x64)
- Android (only [Termux](https://github.com/termux))

## Quick Start

Bootstrap a fresh machine with the official chezmoi entrypoint.
It installs chezmoi into `~/.local/bin`, clones this repository into `~/.local/share/chezmoi`, and applies every dotfile in one command:

```shell
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply ru-461
```

If zsh is not installed yet (for example, on a fresh Ubuntu installation), install it and make it your login shell:

```shell
bash ~/.local/share/chezmoi/install/run.sh --only zsh
```

Reload your shell so the new configuration takes effect.
`.zshrc` adds `~/.local/bin` to `PATH`, so `chezmoi` is available from here on:

```shell
exec zsh
```

(Optional) Install development tools and packages via the bootstrap scripts:

```shell
bash "$(chezmoi source-path)/install/run.sh" --target auto
```

Set your Git identity in `~/.gitconfig.local`.
It is included at the end of `~/.gitconfig` and is not managed by this repository:

```ini
[user]
  name = Your Name
  email = you@example.com
```

That's it. See [Daily Operations](#daily-operations) for editing and updating your dotfiles afterward.

## Daily Operations

```shell
chezmoi diff    # Preview what would change
chezmoi apply   # Update the files in your home directory
chezmoi update  # Pull the latest changes and apply them
```

Edit the source files, not the deployed copies: `chezmoi apply` overwrites the deployed files.
For example, to change `.zshrc` (rendered from the template `dot_zshrc.tmpl`):

```shell
czsh                    # Open the source of ~/.zshrc in VS Code
chezmoi diff ~/.zshrc
chezmoi apply ~/.zshrc
szsh                    # Reload ~/.zshrc
```

Karabiner-Elements rewrites `~/.config/karabiner/karabiner.json` when you change settings in its UI.
Copy those changes back into the source:

```shell
chezmoi re-add ~/.config/karabiner/karabiner.json
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

Environment variables:

- `NONINTERACTIVE=1` runs the Homebrew installer without prompts (Homebrew's unattended installation).
- `DOTFILES_TIMEZONE` sets the time zone on Linux and WSL (default: `Asia/Tokyo`).

```shell
NONINTERACTIVE=1 DOTFILES_TIMEZONE=UTC bash "$(chezmoi source-path)/install/run.sh" --target auto
```

## Upgrading from Older Versions

- The global gitignore moved from `~/.gitignore` to `~/.config/git/ignore`.
  chezmoi does not delete files it no longer manages, so check `~/.gitignore` and remove it manually.

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
