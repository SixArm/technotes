# use-package vs require

For a modern Emacs (you're on 30.2, where `use-package` is **built in** — no
install needed), **`use-package` is better** than **`require`** for package
configuration. But they're not really competitors; `use-package` is a
declarative wrapper that _calls_ `require`/`autoload` for you. Here's the honest
breakdown.

## Use `use-package` when configuring a package

```elisp
(use-package org-contacts
  :after org
  :custom
  (org-contacts-files '("~/org/contacts/..."))
  (org-contacts-directory (expand-file-name "~/org/contacts/"))
  :bind ("C-c c" . org-contacts))
```

Why it wins for this:

- **Deferred loading** — `:after`, `:commands`, `:bind`, `:hook` set up autoloads so the package loads only when actually used. Faster startup. Plain `require` loads everything immediately, every launch.
- **One organized block per package** — keybindings, settings, hooks, and load conditions live together instead of scattered across your init.
- **`:custom` respects defcustom semantics** (`:set` functions, type checks) better than raw `setq`.
- **Graceful when missing** — a typo'd or absent package logs a warning instead of aborting the rest of your init.

## Use plain `require` / `with-eval-after-load` when

- You're loading a **built-in** feature that's always present and you want it _now_ (`(require 'org-contacts)`).
- You're **patching or overriding** a package's internals — like the `org-contacts--candidates` redefinition and the avatar/padding tweaks from earlier. Those aren't "configuring a package," they're "run this code once the package is loaded," which is exactly `with-eval-after-load`:

  ```elisp
  (with-eval-after-load 'org-contacts
    (defun org-contacts--candidates (files) ...)
    (setq org-contacts--candidates-cache-list nil))
  ```

## The clean pattern for _your_ setup — use both

They compose. `use-package` owns the normal config; its `:config` (or a matching `with-eval-after-load`) holds your overrides:

```elisp
(use-package org-contacts
  :after org
  :custom
  (org-contacts-files '("~/org/contacts/gig-cymru/..."))
  (org-contacts-directory (expand-file-name "~/org/contacts/"))
  :bind ("C-c c" . org-contacts)
  :config
  ;; per-file avatar override from earlier
  (defun org-contacts--candidates (files) ...)
  (setq org-contacts--candidates-cache-list nil))
```

## Bottom line

- **Configuring packages → `use-package`.** Cleaner, lazy-loading, self-contained. It's built into Emacs 30, so there's no reason not to.
- **`require`** is the low-level primitive `use-package` uses under the hood — reach for it (or `with-eval-after-load`) only for eager built-ins or when hanging override code off a package after it loads.

For your org-contacts config specifically: wrap the settings and keybinding in `use-package`, and put the avatar/parsing overrides in its `:config` block. That's the idiomatic Emacs 30 form.
