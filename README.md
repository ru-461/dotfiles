# dotfiles

Any more dotfile.
Configuration scripts that can be used anywhere.

# Support OS

- macOS （Only Apple Silicon）
- Ubuntu （Only x64）
- Android（only Termu x64）

# Installation

Run bootstrap.sh.
Just run this one liner!

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

Happy Hacking!
