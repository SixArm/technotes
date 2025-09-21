# Rust: cross-compile from macOS into Linux

<https://medium.com/better-programming/cross-compiling-rust-from-mac-to-linux-7fad5a454ab1>

If you have installed Rust via brew, then uninstall it because it has issues, then install Rust the typical way:

```sh
brew uninstall rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Add target to rustup:

```sh
rustup target add x86_64-unknown-linux-gnu
```

Edit file `.cargo/config` and add these instructions:

```toml
[target.x86_64-unknown-linux-gnu]
linker = "x86_64-unknown-linux-gnu-gcc"
```

Ensure your path includes `~/.cargo/bin` or equivalent:

```sh
export PATH="$PATH:$HOME/.cargo/bin"
```

Build a release:

```sh
TARGET_CC=x86_64-unknown-linux-gnu cargo build --release --target x86_64-unknown-linux-gnu
```

The release file is a Windows executable and saved here:

```sh
ls target/x86_64-pc-windows-gnu/release/*.exe 
```

## Commands

Show the active toolchain, home, profile, etc.:

```sh
rustup show
```

Show target list i.e. all supported targets:

```sh
rustup target list — shows all
```
