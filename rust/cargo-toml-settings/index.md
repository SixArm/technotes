# Cargo.toml settings

## Faster smaller builds by omitting some debug info

These two `Cargo.toml` snippets tune **debuginfo generation** in the dev profile to speed up builds while keeping useful backtraces. Here's what each piece means.

## The `debug` setting

`debug` controls how much DWARF debug information rustc emits. Possible values:

| Value | Meaning |
|-------|---------|
| `0` / `false` / `"none"` | No debuginfo |
| `"line-tables-only"` | Just line-number tables — enough for **file:line in backtraces and panics**, but no variable/type info for a stepping debugger |
| `"line-directives-only"` | Even more minimal (for profilers) |
| `1` / `"limited"` | Line tables + scopes, no type info |
| `2` / `true` / `"full"` | Everything — full debugger experience |

`"line-tables-only"` is the sweet spot: backtraces still show meaningful file/line locations, but rustc emits far less debug data, so **compiles are faster and `target/` is much smaller**.

## The two scopes

**`[profile.dev.package."*"]`**
Applies to **all dependencies** (the `"*"` glob matches every package) — but *not* your own crate(s). So your code keeps the dev profile's default `debug = 2` (full debuginfo for stepping through your own code), while all the third-party crates drop to line-tables-only. You rarely step into dependency internals with a debugger, so full debuginfo there is wasted compile time and disk.

**`[profile.dev.build-override]`**
Applies to **build-time code**: `build.rs` scripts and **proc-macros**, plus their dependencies. These run *during* compilation, not in your final binary. You almost never debug them interactively, so trimming their debuginfo cuts build time with no real downside.

## Net effect

A common, well-tuned dev config that says:

> "Give **my** code full debuginfo, but give **dependencies** and **build/proc-macro code** only line tables."

Result: noticeably faster incremental builds and a smaller `target/` directory, while panics and backtraces *everywhere* still report accurate `file:line` locations. The only thing you lose is the ability to inspect variables/types inside dependencies or build scripts in a debugger like `lldb`/`gdb` — which is almost never something you want anyway.

If you ever *do* need to deep-debug a specific dependency, you can temporarily bump just that one:

```toml
[profile.dev.package.some_crate]
debug = 2
```
