# dist

<https://github.com/axodotdev/cargo-dist/blob/main/book/src/quickstart/rust.md>

The `dist` program is a souped-up version of cargo build which handles building tarballs and installers. It also knows how to generate Githœub CI for orchestrating itself and uploading its output to a new GitHub Release.

However, the `cargo-dist` crate seems unmaintained and its website seems hijacked as of 2025-06-01.

So we prefer to install a fork by Astral:

```sh
cargo install --git https://github.com/astral-sh/cargo-dist cargo-dist
```

Setup dist in your project:

```sh
dist init --yes
git add .
git commit -am 'Add dist'
```

It's very common for dist init to return an error about the "repository" URLs set in your Cargo.toml. If this happens, no work will be lost. You can just follow the instructions in the error and rerun `dist init`and it will pick up where you left off.

This one-time setup will:

* create your dist config in Cargo.toml

* add a shippable build profile to your Cargo.toml

* generate CI for orchestrating itself in .github/workflows/release.yml

Test it:

* build for the current platform: `dist build`

* check what CI will build: `dist plan`

* check the release process on pull-requests
