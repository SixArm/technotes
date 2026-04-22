# Podman + Rust

## Install

Debian apt:

```sh
sudo apt-get -y install podma
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
```

## Pull Rust base image

For our general-purpose demonstrations we prefer:

- Choose an existing Rust base image via the public Docker registry, over building our own custom base image.

- Choose Debian over Alpine, because we prefer glibc dynamic linking ease-of-use over musl static linking tiny-file-sizes.

- Choose slim over full, because we prefer building for deployments in containers. Both come with rustc and Cargo pre-installed.

- Choose the most-recent Rust over an exact version Rust base image; for production, we always choose an exact version.

Run:

```sh
podman pull docker.io/library/rust:slim
```

## Try the container

Try the Podman Rust container by trying these examples.

### Compile and run a Rust file in a container

Run

```sh
podman run --rm \
  -v $(pwd):/app:Z \
  -w /app \
  docker.io/library/rust:slim \
  sh -c "rustc main.rs && ./main"
```

This command compiles and runs a Rust source file (`main.rs`) inside a temporary container.

Here's what each piece does:

- **`podman run --rm`** — Starts a new container and automatically removes it when it's done. Podman is a Docker-compatible container runtime (you could swap in `docker` and it'd work the same way).

- **`-v $(pwd):/app:Z`** — Mounts your current working directory into the container at `/app`. `$(pwd)` expands to your current directory on the host. The `:Z` suffix tells Podman to relabel the files for SELinux so the container process can actually read/write them (relevant on Fedora, RHEL, etc. — harmless elsewhere).

- **`-w /app`** — Sets the working directory inside the container to `/app`, so all commands run from there (where your files are mounted).

- **`docker.io/library/rust:slim`** — The container image to use. This is the official Rust image (slim variant, which is smaller than the full image). It comes with `rustc` and Cargo pre-installed.

- **`sh -c "rustc main.rs && ./main"`** — The command to run inside the container. It does two things chained with `&&` (so the second only runs if the first succeeds):
  - 1. `rustc main.rs` — compiles your Rust source file into a binary called `main`

  - 2. `./main` — runs the compiled binary

The net effect: you get to compile and run Rust code without installing Rust on your host machine. The container spins up, does the work, prints any output, and then vanishes (`--rm`).

### Start an interactive shell with Rust tools available:

```sh
podman run -it --rm \
  -v $(pwd):/app:Z \
  -w /app \
  docker.io/library/rust:slim \
  sh
```

This command drops you into an interactive shell inside a Rust container.

Here's each piece:

- **`podman run -it --rm`** — Starts a new container and automatically removes it when it's done. Podman is a Docker-compatible container runtime (you could swap in `docker` and it'd work the same way).
  - **`-i`** (interactive) keeps stdin open so you can type into the container
  - **`-t`** (tty) allocates a terminal so you get a proper shell prompt with line editing, arrow keys, etc.
  - **`--rm`** (remove) removes the container when you exit

- **`-v $(pwd):/app:Z`** — Mounts your current working directory into the container at `/app`. `$(pwd)` expands to your current directory on the host. The `:Z` suffix tells Podman to relabel the files for SELinux so the container process can actually read/write them (relevant on Fedora, RHEL, etc. — harmless elsewhere).

- **`-w /app`** — Sets the working directory inside the container to `/app`, so all commands run from there (where your files are mounted).

- **`docker.io/library/rust:slim`** — The container image to use. This is the official Rust image (slim variant, which is smaller than the full image). It comes with `rustc` and Cargo pre-installed.

- **`sh`** — Instead of running a one-shot compile-and-run command, this just opens a shell. You're now sitting at a prompt inside the container.

From there you can do whatever you want interactively — compile files, run them, inspect errors, use `cargo init` to start a project, iterate on your code, etc. For example:

```sh
# You're now inside the container
rustc main.rs && ./main
cargo build
cargo run
```

The main difference from the previous command is workflow style: the first was "fire and forget" (run one command, get the output, container disappears), while this one is "sit inside the environment and work." When you type `exit` or press `Ctrl+D`, the shell ends and the container is removed.

## Container file

````container
```container
# =============================================================================
# Rust Development Container
# =============================================================================
# This Containerfile (also called a Dockerfile) creates a development image
# for Rust projects with live-reloading. Build it with:
#
#   podman build -t my-rust-app .
#
# Run it with:
#
#   podman run --rm -p 8080:8080 -v $(pwd):/app:Z my-rust-app
#
# =============================================================================

# -----------------------------------------------------------------------------
# Base image
# -----------------------------------------------------------------------------
# Start from the official Rust "slim" image, which includes rustc, cargo, and
# the standard library, but omits extras like git and gcc to keep size down.
# "slim" is based on Debian with minimal packages — a good balance between
# size and compatibility. Alternatives:
#   - rust:latest   — full Debian image, larger but more tools pre-installed
#   - rust:alpine   — smallest image, but uses musl libc (can cause issues
#                     with crates that expect glibc)
FROM docker.io/library/rust:slim

# -----------------------------------------------------------------------------
# System dependencies
# -----------------------------------------------------------------------------
# Many Rust crates link to C libraries at build time. We install common ones
# here so cargo build doesn't fail later.
#
#   pkg-config   — helps the compiler find installed C libraries (e.g., openssl).
#                  Without it, crates like "openssl-sys" can't locate headers.
#
#   libssl-dev   — OpenSSL headers and libraries. Required by any crate that
#                  does TLS/HTTPS (reqwest, hyper-tls, native-tls, etc.).
#
#   apt-get update          — refreshes the package index (required before install)
#   && apt-get install -y   — installs packages; -y auto-confirms prompts
#   && rm -rf /var/lib/apt/lists/*  — deletes the cached package index to
#                                     shrink the final image layer. This is a
#                                     standard Docker best practice.
#
# All three commands are chained with && in a single RUN so Docker creates
# only ONE layer instead of three, keeping the image smaller.
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# Development tooling
# -----------------------------------------------------------------------------
# cargo-watch monitors your source files and re-runs a cargo command whenever
# something changes — like nodemon for Node.js. This gives us live-reloading:
# save a file, and the app automatically recompiles and restarts.
#
# This is installed in a separate RUN so it gets its own cached layer.
# Since cargo-watch rarely changes, Docker won't re-download it when you
# update your source code or dependencies.
RUN cargo install cargo-watch

# -----------------------------------------------------------------------------
# Working directory
# -----------------------------------------------------------------------------
# All subsequent commands (RUN, COPY, CMD) will execute relative to /app.
# If /app doesn't exist, WORKDIR creates it automatically.
WORKDIR /app

# -----------------------------------------------------------------------------
# Dependency caching (the most important optimization in this file)
# -----------------------------------------------------------------------------
# Problem: Rust dependency compilation is SLOW. A full `cargo build` can take
# minutes. Without this trick, changing a single line of your source code
# would re-download and recompile every dependency.
#
# Solution: Copy ONLY the manifest files first, build dependencies in an
# isolated step, then copy the real source code afterward. Here's why it works:
#
# Docker caches each layer. If the input files haven't changed, Docker skips
# that step entirely and reuses the cache. By separating "dependency files"
# from "source files," we get two cache layers:
#
#   Layer 1 (this step)  — only rebuilds when Cargo.toml or Cargo.lock changes
#   Layer 2 (later step) — rebuilds when your .rs source files change
#
# So day-to-day code changes skip the expensive dependency compilation entirely.
#
# The glob "Cargo.lock*" uses a wildcard because Cargo.lock might not exist
# yet (e.g., for library crates). The wildcard avoids a build error if the
# file is missing.
COPY Cargo.toml Cargo.lock* ./

# Create a minimal placeholder so `cargo build` has something to compile.
# This dummy file satisfies Cargo's requirement for a src/main.rs entry point.
# The actual content doesn't matter — we just need Cargo to resolve, download,
# and compile all the dependencies listed in Cargo.toml.
RUN mkdir src && echo "fn main() {}" > src/main.rs

# This is the expensive step: downloads and compiles all dependencies.
# Thanks to layer caching, this only re-runs when Cargo.toml/Cargo.lock change.
RUN cargo build

# Clean up the dummy source so it doesn't interfere with the real code.
# The compiled dependencies remain cached in /app/target/ and will be reused.
RUN rm -rf src

# -----------------------------------------------------------------------------
# Application source code
# -----------------------------------------------------------------------------
# NOW we copy the actual project files. Since this layer comes after the
# dependency layer, changing your .rs files only triggers a rebuild from
# this point forward — dependencies are already compiled and cached above.
#
# Tip: Use a .containerignore (or .dockerignore) file to exclude things like:
#   target/        — build artifacts (we build inside the container)
#   .git/          — version history (not needed in the image)
#   *.md           — docs that don't affect the build
COPY . .

# -----------------------------------------------------------------------------
# Network
# -----------------------------------------------------------------------------
# EXPOSE documents which port the app listens on. It does NOT actually publish
# the port — it's metadata for humans and tooling. You still need -p at runtime:
#
#   podman run -p 8080:8080 my-rust-app
#
# The left side (host) can be anything; the right side (container) must match
# what your app binds to. If your app uses a different port, change this.
EXPOSE 8080

# -----------------------------------------------------------------------------
# Default command
# -----------------------------------------------------------------------------
# CMD defines what runs when the container starts (can be overridden at runtime).
#
# "cargo watch -x run" means:
#   - cargo watch   — watch all source files for changes
#   - -x run        — execute `cargo run` whenever a change is detected
#
# This gives you a live-reload development loop:
#   1. You edit a .rs file on your host machine
#   2. The bind-mount (-v) makes the change visible inside the container
#   3. cargo-watch detects the change and restarts `cargo run`
#   4. Your updated app is running within seconds
#
# The exec form ["cmd", "arg", ...] is preferred over the shell form
# ("cmd arg ...") because it runs cargo-watch as PID 1, which means it
# receives SIGTERM directly when you stop the container — enabling clean
# shutdown instead of a 10-second timeout.
CMD ["cargo", "watch", "-x", "run"]
````

Add to `.dockerignore`:

```txt
target
.git
.gitignore
*.md
.vscode
.env
```
