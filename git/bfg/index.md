# BFG to delete files in git

To fix an accidental commit of large files, such as to delete all the
directories named `images`, you can use the git tool "BFG".

* https://rtyley.github.io/bfg-repo-cleaner/

To fix via remote, not via local:

```sh
git clone --mirror git@github.com:user/repo.git
java -jar bfg-1.13.0.jar --delete-folders images repo.git
cd repo.git
git reflog expire --expire=now --all
git gc --aggressive --prune=now
git push
```

To fix via local, not remote, you must be in the directory above the repo:

```sh
git gc
java -jar bfg-1.13.0.jar --delete-folders images demo_app
cd demo_app
git reflog expire --expire=now --all
git gc --aggressive --prune=now
git push -f
```
