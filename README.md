# dotfiles

Any more dotfile.
Configuration scripts that can be used anywhere.

# Support OS

- macOS （Only [Apple Silicon](https://support.apple.com/en-us/HT211814)）
- Ubuntu （Only x64）
- Android（only [Termux](https://github.com/termux) x64）

# Installation

Run ./bootstrap.sh.
Just run this one liner.

```shell
bash <(curl -fsSL raw.githubusercontent.com/ryu-461/dotfiles/main/bootstrap.sh)
```

# Try using Docker

Try dotfiles easily using Docker.
Build images in a locally cloned dotfiles repository.

```shell
docker build -t dotfiles --force-rm .
```

The latest Ubuntu-based container will be launched.

```shell
docker run -it --rm dotfiles
```

Run bootstrap.sh in container.

```shell
bash bootstrap.sh
```

You can test with the following users.

- User: docker
- Password: docker

Happy Hacking！
