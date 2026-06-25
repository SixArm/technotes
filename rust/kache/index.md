# Kache

Here's how `kache` stacks up against just pointing multiple builds at a shared `target/` directory (`CARGO_TARGET_DIR` / `[build] target-dir`).

## What each one actually is

**Shared target directory** — You set `CARGO_TARGET_DIR` (or `build.target-dir`) so multiple checkouts/worktrees/projects compile into one common `target/`. Cargo's normal fingerprinting decides what to reuse. Pure Cargo, no extra tooling.

**kache** — A `RUSTC_WRAPPER` that content-addresses every compilation by a blake3 hash of all inputs (source, deps, full rustc version + commit + host triple). Local hits are restored as **hardlinks** into each `target/`, so artifact bytes aren't copied. It can also sync the store to any S3-compatible backend (R2, MinIO, Ceph, AWS) for sharing across machines/CI.

## Comparison

| Dimension | Shared `target/` | kache |
|---|---|---|
| Setup | One env var, zero deps | Install binary + set `RUSTC_WRAPPER`; optional S3 config |
| Cross-machine / CI sharing | ❌ Local only | ✅ S3 sync — "has anyone, anywhere built this?" |
| Reuse model | Cargo fingerprints (path/profile sensitive) | Content-addressed; reuses across branches & worktrees freely |
| Disk usage with N worktrees | Better than N separate dirs, but each output still materialized | One physical copy, hardlinked N times |
| Concurrency safety | ⚠️ Two `cargo` runs against one dir contend on the lock / can clobber | Each worktree keeps its own `target/`, links from a shared store |
| Failure mode | Cargo's well-understood, stable | Newer tool; wrapper adds a layer that can mis-key or break |
| Cleaning | `cargo clean` / manual | Store managed separately; GC story is its own |

## Pros / cons

**Shared target directory**
- ✅ Zero dependencies, dead simple, fully supported by Cargo upstream.
- ✅ No wrapper layer to debug; behavior is predictable.
- ❌ Only helps on one machine — nothing for CI or teammates.
- ❌ Concurrent builds (parallel CI jobs, two worktrees building at once) **contend on the same lock and can invalidate each other's fingerprints** — a common source of spurious rebuilds. Designed for serial reuse, not parallel.
- ❌ Reuse is sensitive to absolute paths and profile differences; switching branches often still triggers rebuilds.

**kache**
- ✅ Reuse keyed by content, not path — branch-switching and fresh worktrees hit cache that a shared dir would miss.
- ✅ Hardlinks mean near-zero marginal disk per extra worktree.
- ✅ S3 backend gives you real distributed/CI caching (the thing a shared dir fundamentally can't do).
- ✅ Each worktree keeps an independent `target/`, sidestepping the lock-contention problem.
- ❌ Extra moving part: a `RUSTC_WRAPPER` that can break, mis-key, or lag behind toolchain changes.
- ❌ Younger/less battle-tested than plain Cargo; you own its cache GC and store maintenance.
- ❌ S3 sharing adds infra, network latency, and (for proc-macros/build scripts) the usual caveats about non-deterministic or environment-dependent outputs.

## Recommendation

- **Single dev machine, a few projects, want simplicity** → shared `target/` is enough and has nothing to maintain.
- **Many git worktrees / branches in parallel, or you want to share with CI and teammates** → kache is the better fit; it's specifically built for the worktree + CI + S3 case that a shared directory can't address, and it avoids the parallel-build contention that makes a shared `target/` flaky.

They're also **not mutually exclusive** — kache replaces the *artifact reuse* mechanism, so you'd typically run it instead of (not on top of) a shared-target setup. If you mainly care about cross-machine sharing, note `sccache` is the more mature alternative to compare kache against.

Sources:
- [kunobi-ninja/kache (GitHub)](https://github.com/kunobi-ninja/kache)
- [Open-sourcing kache: a Rust build cache and sccache alternative](https://kunobi.ninja/blog/open-sourcing-kache)
- [Content-addressed Rust builds (what kache actually caches)](https://kunobi.ninja/blog/what-kache-actually-caches)
- [Build Cache — The Cargo Book](https://doc.rust-lang.org/cargo/reference/build-cache.html)