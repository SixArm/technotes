# sccache

## Rust sscache

For Rust projects, we recommend using a Rust cache for dependencies.

We recommend the Rust cache program `sscache`.

How to start the server:

```sh
sccache --start-server
```

## Stats

How to show stats:

```sh
sccache --show-stats
```

In particular, look for the "Max cache size" line near the bottom.

## Change cache size

sccache looks in a platform-specific location by default:

- Linux: `~/.config/sccache/config`
- macOS: `~/Library/Application Support/Mozilla.sccache/config`
- Windows: `%APPDATA%\Mozilla\sccache\config\config`

macOS:

```sh
mkdir -p ~/Library/Application\ Support/Mozilla.sccache
cd $_
edit config
```

Add TOML to set the cache disk size to 100 GiB or whatever you wish:

```toml
[cache.disk]
size = 107374182400 # 100 GiB
```

Restart the server, then verify the max cache size is what you wish:

```sh
sccache --stop-server
sccache --start-server
sccache --show-stats
```

## If you prefer env vars

If the sccache server is already running, and you want to change the max cache size, then you must stop the server, then set the new max cache size, then start the server:

```sh
sccache --stop-server
export SCCACHE_CACHE_SIZE="10G"
sccache --start-server
```

- We recommend sscache configuration via environment variables, or in an environment file such as `~/.bashrc` or `~/.zshenv`, or in the cargo config file for the user `~/.cargo/config.toml` or project `.cargo/config.toml`.

- We recommend increasing the cache size from the default 100G to 80G, if you have enough drive space.

```sh
export RUSTC_WRAPPER="sccache"
export SCCACHE_CACHE_SIZE="80G"
```
