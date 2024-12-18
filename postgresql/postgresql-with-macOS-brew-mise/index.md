# PostgreSQL with macOS, brew, mise

Install prerequisites via brew:

```sh
brew install gcc readline zlib curl openssl@1.1 ossp-uuid icu4c pkg-config
```

Install PostgreSQL via mise:

```sh
PKG_CONFIG_PATH="$(brew --prefix)/lib/pkgconfig:$(brew --prefix icu4c)/lib/pkgconfig" \
LDFLAGS="-L$(brew --prefix)/lib" \
CPPFLAGS="-I$(brew --prefix)/include" \
mise use postgres --verbose
```

Result:

```
$HOME/.local/share/mise/installs/postgres/17.2/
```

Print the installation directory:

```sh
mise where postgres
```

Print the binary file:

```sh
mise which postgres
```

If you wish to track the installation directory:

```sh
export x="$(mise where postgres)"
```

Start:

```sh
"$x/bin/pg_ctl" -D "$x/data" -l "$x/log" start 
```

Stop:

```sh
"$x/bin/pg_ctl" -D "$x/data" stop --mode smart
```


## Demo

Create a role:

```sh
psql -U postgres -c "CREATE ROLE demo_owner WITH LOGIN ENCRYPTED PASSWORD 'secret';"
```

Create a database:

```sh
psql -U postgres -c "CREATE DATABASE demo_development with owner = demo_owner;"
```

If you ever need to redo a demo database:

```sh
psql -U postgres 
-c 'drop database if exists demo_development' 
-c 'create database demo_development with owner = demo_owner;'
```

Restore a demo database:

```sh
pg_restore --exit-on-error   -U demo_owner --no-owner --role=heron_owner -d demo_development -1 demo_development.dump 
```
