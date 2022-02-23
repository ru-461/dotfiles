# dotfiles

My settings and any more dotfiles.
Configuration scripts that can be used anywhere.

# Support OS

- macOS（Only arm64）
- WSL2 （Only Ubuntu x64）
- Ubuntu（x64）
- Linux（x64）

# How to use

Run bootstrap.sh !
Just run this one-liner！

```shell
bash <(curl -fsSL raw.githubusercontent.com/ryu-461/dotfiles/main/bootstrap.sh)
```

# Try using Docker

Try dotfile easily using Docker.

```shell
docker build -t --force-rm dotfiles .
```

Deploy dotfiles in Ubuntu container.

```shell
docker run -it --rm dotfiles
```

Run bootstrap.sh in container.

```shell
. bootstrap.sh
```

Happy Hacking!!