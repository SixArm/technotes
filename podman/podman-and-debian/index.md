# Podman + Debian

## Install

Debian apt:

```sh
sudo apt-get -y install podman
```

macOS brew:

```sh
brew install podman
```

## Init & Start

Run:

```sh
podman machine init
podman machine start
podman machine list
```

## Launch

Option 1: create & run a container:

```sh
podman run -it --name alfa debian:13
```

Option 2: create a container, then start it using attach interactive:

```sh
podman create -it --name alfa debian:13
podman start -ai alfa
podman exec -it alfa bash
```

## Optional: install a program

To install a binar program name "app" from the local system into a container name "alfa":

```sh
podman cp /a/b/c/app alfa:/x/y/z/app
```

Example using my "vix" program which is a Rust MUSL binary:

```sh
podman cp ~/git/vixide/vix/target/x86_64-unknown-linux-musl/release/vix alfa:/usr/local/bin/
```
