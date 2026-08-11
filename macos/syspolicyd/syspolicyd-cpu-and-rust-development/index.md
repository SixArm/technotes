# syspolicyd CPU and Rust development

`syspolicyd` is Gatekeeper and XProtect assessing every freshly linked binary under `target/debug/deps`. Each cargo build or test run produces hundreds of new executables, and each one gets scanned. This sandbox is Linux, so I can't test any of this on your Mac. These are the standard fixes, most effective first.

1. **Give your terminal Developer Tools status.** This is the real fix. It exempts processes launched from that terminal from the scan:

   ```bash
   sudo spctl developer-mode enable-terminal
   ```

   Then open System Settings → Privacy & Security → Developer Tools and switch on your terminal app (Terminal, iTerm, Ghostty, or whichever you use). Do the same for VS Code or any other IDE that runs cargo. Fully quit and reopen the app afterwards.

## Stop Spotlight

Stop Spotlight from indexing target output.

This cuts the `mds` and `mdworker` load that stacks on top:

```sh
touch target/.metadata_never_index
```

Script to block Spotlight from indexing all target directories:

```sh
find . -name '.*' -prune -o -type d -name target -prune -exec touch {}/.metadata_never_index \;
```

You can also add `target` to Spotlight's privacy list.

3. **Cut the number of binaries.** Each integration test file in `tests/` becomes its own executable, which multiplies the scans. Setting `debug = "line-tables-only"` (or `debug = 0`) under `[profile.dev]` also shrinks the binaries, which makes them cheaper to scan. If there are many `tests/*.rs` files, consolidate them into one binary.

4. **Clear a stuck scan.** If `syspolicyd` stays pegged after a build finishes, run `cargo clean` in that crate. This works only because you're deleting thousands of files that it keeps rescanning. Restarting the Mac also resets the scan cache.

This repo uses a separate cargo workspace per crate, so every crate has its own `target/` directory. Step 1 covers all of them at once, and step 2 needs repeating per crate.
