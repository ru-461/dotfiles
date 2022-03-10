# dotfiles

My settings and any more dotfiles.
Configuration scripts that can be used anywhere.

# Support OS

- macOS（Only arm64）
- Ubuntu（x64）

# How to use

Run bootstrap.sh !
Just run this one-liner！

```shell
bash <(curl -fsSL raw.githubusercontent.com/ryu-461/dotfiles/main/bootstrap.sh)
```

# Try using Docker

Try dotfiles easily using Docker.

```shell
docker build -t dotfiles --force-rm .
```


```shell
docker run -it --rm dotfiles
```

Run bootstrap.sh in Ubuntu container.

```shell
bash bootstrap.sh
```

Happy Hacking!!