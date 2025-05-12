# Rust: cross-compile from macOS to Windows

If you have installed Rust via brew, then uninstall it because it has issues, then install Rust the typical way:

```sh
brew uninstall rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Install Minimalist GNU for Windows via macOS brew:

```sh
brew install mingw-w64
```

Verify in various ways:

```sh
brew --cellar mingw-w64
brew list --formula mingw-w64
readlink -f $(brew --prefix mingw-w64)
```

Add target to rustup:

```sh
rustup target add x86_64-pc-windows-gnu
```

Edit file `.cargo/config` and add these instructions:

```toml
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
```

Ensure your path includes `~/.cargo/bin` or equivalent:

```sh
export PATH="$PATH:$HOME/.cargo/bin"
```

## Commands

Show the active toolchain, home, profile, etc.:

```sh
rustup show — shows targets amn toolchain
```

Show target list i.e. all supported targets:

```sh
rustup target list — shows all
```

## Troubleshooting

If you need to copy files, then try:

```sh
cp -f "$(readlink -f $(brew --prefix mingw-w64))/toolchain-x86_64/x86_64-w64-mingw32/lib/{,dll}crt2.o" "$(rustc --print sysroot)/lib/rustlib/x86_64-pc-windows-gnu/lib/"
```
