# Postgres via macOS brew services

```sh
% sudo brew services start postgresql@18
Warning: Taking root:admin ownership of some postgresql@18 paths:
  /opt/homebrew/Cellar/postgresql@18/18.4/bin
  /opt/homebrew/Cellar/postgresql@18/18.4/bin/postgres
  /opt/homebrew/opt/postgresql@18
  /opt/homebrew/opt/postgresql@18/bin
  /opt/homebrew/var/homebrew/linked/postgresql@18
This will require manual removal of these paths using `sudo rm` on
brew upgrade/reinstall/uninstall.
Warning: postgresql@18 must be run as non-root to start at user login!
==> Successfully started `postgresql@18` (label: homebrew.mxcl.postgresql@18)
```
