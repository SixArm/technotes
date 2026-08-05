# org-contacts emacs init

## Init via require

In your emacs init file, such as `~/.emacs.d/init.el`, require org-contacts, then configure how you want to load any of your org files such as:

```elisp
(require 'org-contacts)
(setq org-contacts-files (directory-files-recursively "~/org/contacts/" "\\.org$"))
(global-set-key (kbd "C-c c") #'org-contacts)
```

## Init via use-package

```elisp
;;; org-contacts setup

(use-package org-contacts
  :ensure t                                  ; drop this line if it ships with your Org
  :after org
  :custom
  (org-contacts-files '("~/org/contacts.org"))
  :bind
  ;; Quick access from anywhere:
  ("C-c c" . org-contacts))
```

## Capture template

A capture template makes it easy to a contact:

```elisip
(add-to-list 'org-capture-templates
  '("c" "Contact" entry
    (file "~/org/contacts.org")
    "* %^{Name}
:PROPERTIES:
:EMAIL:     %^{Email}
:PHONE:     %^{Phone}
:BIRTHDAY:  %^{Birthday (YYYY-MM-DD)}
:NOTE:      %^{Note}
:END:"
    :empty-lines 1))
```

Then `M-x org-capture →  c` adds a contact interactively.

## Run

`M-x org-contacts` shows a search prompt:

- Press RET → show all your contacts.
- Type part of a name/email → filter live as you type, then RET.

## Auto-update

To update your contact files automatically, you can wrap the recursive file search in a custom function and add it to org-contacts-mode-hook. This ensures Emacs rescans the directory every time you work with your contacts.

```elisp
;; org-contacts auto-update
;;
;; - my-org-contacts-dir: Sets your base folder pathway once.
;;
;; - advice-add: Forces a folder rescan immediately before you launch a contact search.
;;
;; - add-hook: Refreshes the file list whenever you open a dedicated contact buffer.

(defvar my-org-contacts-dir "~/org/contacts/"
  "The root directory containing your org-contacts files.")

(defun my-update-org-contacts-files ()
  "Dynamically find all .org files recursively in `my-org-contacts-dir`."
  (when (file-directory-p my-org-contacts-dir)
    (setq org-contacts-files
          (directory-files-recursively my-org-contacts-dir "\\.org$"))))

(add-hook 'org-contacts-mode-hook #'my-update-org-contacts-files)
(advice-add 'org-contacts :before #'my-update-org-contacts-files)
```

## Starter

```org
#+TITLE: Contacts
#+CATEGORY: Contacts

* Jane Doe
  :PROPERTIES:
  :EMAIL:     jane@example.com
  :END:

* John Smith
  :PROPERTIES:
  :EMAIL:     john@example.org
  :END:
```

## Troubleshoot

Verify init.el is the init file:

- `C-h v user-init-file`

To see which files are loaded in org-contacts, do any of these

- `C-h v org-contacts-files`

- `M-x describe-variable` then `org-contacts-files`

- Press `M-:` (`eval-expression`). Type `org-contacts-files` then enter.

The paste this whole block into _scratch_, put point at the very end, and press C-x C-e:

```elisp
(message "files=%S | exists=%S | size=%S"
         org-contacts-files
         (file-exists-p (expand-file-name (car org-contacts-files)))
         (nth 7 (file-attributes (expand-file-name (car org-contacts-files)))))
```

### How many contacts did org-contacts parse?

`M-:`

Then paste:

```elisp
(length (org-contacts-db))
```

That reads its internal database. The result splits the diagnosis cleanly:

- 0 → parsing/collection is failing. Cause is almost certainly the lowercase drawer (see below).

- A number > 0 → the data is fine and the issue is the completion UI — you just need to type differently at the prompt (also below).
