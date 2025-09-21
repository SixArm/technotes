# Rust cross-compile release builds

Rust cross-compile release builds has many optons.

* `dist`: didn't work well for me; see my technote.


### GNU or MUSL

For Rust builds that target Linux, there is a signficant choice between Linux GNU and Linux MUSL.

* Linux GNU is widespread and includes very popular Linux distributions such as Debian.

* Linux MUSL is rare yet includes specialized popular Linux distributions such as Alpine.

We choose build a Linux statically-linked binary because it will run on more systems than Linux GNU.


### Use musl-cross

Run:

```sh
brew install filosottile/musl-cross/musl-cross
rustup target add x86_64-unknown-linux-musl
```

Specify in our project root that we are going to use the musl linker. 

Put this into .cargo/config:

```toml
[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"
```

Build:

```sh
TARGET_CC=x86_64-linux-musl-gcc \
RUSTFLAGS="-C linker=x86_64-linux-musl-gcc" \
cargo build --target=x86_64-unknown-linux-musl
```

Optional: install Nanos and Ops unikernel:

<https://github.com/nanovms/nanos>

Install:

```sh
curl https://ops.city/get.sh -sSfL | sh
```

The installer should print a message about updating your environment file, and you might need to source it, such as:

```sh
.  ~/.zshrc
```

### Use the cross crate - failure


To install the cross crate, we prefer the current version because it fixes some bugs we hit in macOS.

Run:

```sh
cargo install cross --git https://github.com/cross-rs/cross
```

Run:

```sh
cross run --target x86_64-unknown-linux-musl 
```

### Troubleshoot Docker

If you get this error…

```stderr
docker: Error response from daemon: failed to resolve reference "ghcr.io/cross-rs/x86_64-unknown-linux-musl:0.2.5": failed to authorize: failed to fetch anonymous token: Get "https://ghcr.io/token?scope=repository%3Across-rs%2Fx86_64-unknown-linux-musl%3Apull&service=ghcr.io": unexpected EOF.
```

…then verify you can sign in to Docker

```sh
docker login --username <username>
```

### Troubleshoot networking

If you use MacOS check if there are any kind of System Extensions which intercept the traffic - e.g. firewalls, vpn clients, security tools. 

Run:

```sh
systemextensionsctl list
```


###

Setup:

```sh
xcode-select --install
brew install filosottile/musl-cross/musl-cross
rustup update
rustup target add aarch64-unknown-linux-musl
rustup target add x86_64-unknown-linux-musl
```

If you get an error similar to error: toolchain 'stable-x86_64-unknown-linux-gnu' does not support components, try reinstalling that toolchain with rustup.

```sh
rustup toolchain uninstall stable-x86_64-unknown-linux-gnu
rustup toolchain install stable-x86_64-unknown-linux-gnu --force-non-host
```

Build:

```sh
cargo build --target=aarch64-unknown-linux-musl
cargo build --target=x86_64-unknown-linux-musl
```



rustup target add x86_64-unknown-linux-gnu


To use this with Rust, add an entry to .cargo/config and use the corresponding target.

```toml
[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"
```

By default it will install full cross compiler toolchains targeting musl Linux amd64 and arm64.

You can then use x86_64-linux-musl- or aarch64-linux-musl- versions of the tools to build for the target. For example x86_64-linux-musl-cc will compile C code to run on musl Linux amd64.

The "musl" part of the target is important: the binaries will ONLY run on a musl-based system, like Alpine. However, if you build them as static binaries by passing -static as an LDFLAG they will run anywhere. Musl is specifically engineered to support static binaries.


