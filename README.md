# dotfiles

Any more dotfiles.
Configuration scripts that can be used anywhere.

# Features

- Identifies OS and platform and makes only appropriate settings
- Easy to try with docker
- Easy to deploy

# Support OS

- macOS  （Only [Apple Silicon](https://support.apple.com/en-us/HT211814)）
- Ubuntu （Only x64）
- Android（only [Termux](https://github.com/termux) x64）

# Installation

Just run this one liner.

```shell
bash <(curl -fsSL https://raw.githubusercontent.com/ryu-461/dotfiles/main/bootstrap.sh)
```

# Try Docker

Try dotfiles easily using Docker.
Build images in a locally cloned dotfiles repository.

```shell
docker build -t dotfiles --force-rm .
```

The latest Ubuntu-based container will be launched.

```shell
docker run -it --rm dotfiles
```

Run bootstrap.sh in docker container.

```shell
bash bootstrap.sh
```

You can test with the following users.

- User： docker
- Password： docker

Happy Hacking！
