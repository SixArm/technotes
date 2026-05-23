# MasaCMS demo

https://masacms.com

https://docs.masacms.com/getting-started/

## Source code

https://github.com/MasaCMS/

Clone:

```sh
git clone https://github.com/MasaCMS/MasaCMS.git
```

## Install

Masa CMS needs:

- [CommandBox](https://www.ortussolutions.com/products/commandbox)

### macOS brew

Install via macOS brew:

```sh
brew install commandbox
```

Optional - to run as a different user on the system:

```sh
sudo chmod g+rx /opt/homebrew/Cellar/commandbox/6.3.3/libexec/bin/box
```

Run:

```sh
/opt/homebrew/Cellar/commandbox/6.3.3/bin/box
```

```stdout
Configuring CommandBox home: /Users/brew/.CommandBox (change with -CommandBox_home=/path/to/dir)
Library path: /Users/brew/.CommandBox/lib
Initializing libraries -- this will only happen once, and takes a few seconds...
...
Libraries initialized

Checking to see if your CLI version is current...
Getting stable versioning information from https://downloads.ortussolutions.com/ortussolutions/commandbox/box-repo.json
Your version of CommandBox (6.3.3+00860) is already current (6.3.3).

Checking to see if your system modules are current...
Checking for outdated system dependencies, please wait...
There are no outdated dependencies!

   ______                                          ______
  / ____/___  ____ ___  ____ ___  ____ _____  ____/ / __ )____  _  __
 / /   / __ \/ __ `__ \/ __ `__ \/ __ `/ __ \/ __  / __  / __ \| |/_/
/ /___/ /_/ / / / / / / / / / / / /_/ / / / / /_/ / /_/ / /_/ />  <
\____/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/_____/\____/_/|_| (R)  v6.3.3+00860

                                   Turning IT nightmares into pleasant dreams

Welcome to CommandBox!
CommandBox:brew>
```

Install MasaCMS:

```commandbox
CommandBox> install MasaCMS
```

```out
| Installing package [forgebox:MasaCMS]
| Verifying package 'MasaCMS' in forgebox, please wait...
| Installing version [7.5.4].
| Verified entry in forgebox: 'MasaCMS'
| Deferring to [https] endpoint for forgebox entry [MasaCMS]...
| Downloading [HTTPS://github.com/MasaCMS/MasaCMS/archive/refs/tags/7.5.4.zip]
| Redirecting to: 'https://codeload.github.com/MasaCMS/MasaCMS/zip/refs/tags/7.5.4'...
| Decompressing...
| Storing download in artifact cache...
| Done.
| /Users/brew//box.json updated with dependency.

To enable full stack trace, run config set verboseErrors=true

CommandBox:brew>
```

Quit:

```sh
CommandBox:brew> quit
```

The result is your directory now has a MasaCMS installation.

## Launch

Run:

```sh
cd core/docker/local-posgresql/
docker compose up
```

```out
Attaching to mura_postgres-1, mura_postgres_cfml-1
mura_postgres-1       | The files belonging to this database system will be owned by user "postgres".
mura_postgres-1       | This user must also own the server process.
mura_postgres-1       |
mura_postgres-1       | The database cluster will be initialized with locale "en_US.utf8".
mura_postgres-1       | The default database encoding has accordingly been set to "UTF8".
mura_postgres-1       | The default text search configuration will be set to "english".
mura_postgres-1       |
mura_postgres-1       | Data page checksums are disabled.
mura_postgres-1       |
mura_postgres-1       | fixing permissions on existing directory /var/lib/postgresql/data ... ok
mura_postgres-1       | creating subdirectories ... ok
mura_postgres-1       | selecting dynamic shared memory implementation ... posix
mura_postgres_cfml-1  | [WARN] 2026-05-20T13:43:11Z - The environment variable CFENGINE has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_APP_CFENGINE instead.
mura_postgres_cfml-1  | [WARN] 2026-05-20T13:43:11Z - The environment variable URL_REWRITES has been deprecated. Support will be discontinued in a future release. Please use BOX_SERVER_WEB_REWRITES_ENABLE instead.
mura_postgres-1       | selecting default "max_connections" ... 100
mura_postgres-1       | selecting default "shared_buffers" ... 128MB
mura_postgres-1       | selecting default time zone ... Etc/UTC
mura_postgres-1       | creating configuration files ... ok
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:11Z - Server Home Directory set to: /usr/local/lib/serverHome
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:11Z - Generating server startup script
mura_postgres_cfml-1  | Picked up JAVA_TOOL_OPTIONS: -Djava.util.logging.config.file=/usr/local/lib/build/resources/text.logging.properties
mura_postgres-1       | running bootstrap script ... ok
mura_postgres-1       | performing post-bootstrap initialization ... ok
mura_postgres-1       | initdb: warning: enabling "trust" authentication for local connections
mura_postgres-1       | initdb: hint: You can change this by editing pg_hba.conf or using the option -A, or --auth-local and --auth-host, the next time you run initdb.
mura_postgres-1       | syncing data to disk ... ok
mura_postgres-1       |
mura_postgres-1       |
mura_postgres-1       | Success. You can now start the database server using:
mura_postgres-1       |
mura_postgres-1       |     pg_ctl -D /var/lib/postgresql/data -l logfile start
mura_postgres-1       |
mura_postgres-1       | waiting for server to start....2026-05-20 13:43:12.001 UTC [48] LOG:  starting PostgreSQL 17.2 (Debian 17.2-1.pgdg120+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit
mura_postgres-1       | 2026-05-20 13:43:12.002 UTC [48] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
mura_postgres-1       | 2026-05-20 13:43:12.004 UTC [51] LOG:  database system was shut down at 2026-05-20 13:43:11 UTC
mura_postgres-1       | 2026-05-20 13:43:12.005 UTC [48] LOG:  database system is ready to accept connections
mura_postgres-1       |  done
mura_postgres-1       | server started
mura_postgres-1       | CREATE DATABASE
mura_postgres-1       |
mura_postgres-1       |
mura_postgres-1       | /usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*
mura_postgres-1       |
mura_postgres-1       | waiting for server to shut down....2026-05-20 13:43:12.152 UTC [48] LOG:  received fast shutdown request
mura_postgres-1       | 2026-05-20 13:43:12.152 UTC [48] LOG:  aborting any active transactions
mura_postgres-1       | 2026-05-20 13:43:12.153 UTC [48] LOG:  background worker "logical replication launcher" (PID 54) exited with exit code 1
mura_postgres-1       | 2026-05-20 13:43:12.154 UTC [49] LOG:  shutting down
mura_postgres-1       | 2026-05-20 13:43:12.154 UTC [49] LOG:  checkpoint starting: shutdown immediate
mura_postgres-1       | 2026-05-20 13:43:12.195 UTC [49] LOG:  checkpoint complete: wrote 921 buffers (5.6%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.005 s, sync=0.036 s, total=0.042 s; sync files=301, longest=0.023 s, average=0.001 s; distance=4238 kB, estimate=4238 kB; lsn=0/1908948, redo lsn=0/1908948
mura_postgres-1       | 2026-05-20 13:43:12.197 UTC [48] LOG:  database system is shut down
mura_postgres-1       |  done
mura_postgres-1       | server stopped
mura_postgres-1       |
mura_postgres-1       | PostgreSQL init process complete; ready for start up.
mura_postgres-1       |
mura_postgres-1       | 2026-05-20 13:43:12.262 UTC [1] LOG:  starting PostgreSQL 17.2 (Debian 17.2-1.pgdg120+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit
mura_postgres-1       | 2026-05-20 13:43:12.263 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
mura_postgres-1       | 2026-05-20 13:43:12.263 UTC [1] LOG:  listening on IPv6 address "::", port 5432
mura_postgres-1       | 2026-05-20 13:43:12.264 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
mura_postgres-1       | 2026-05-20 13:43:12.265 UTC [64] LOG:  database system was shut down at 2026-05-20 13:43:12 UTC
mura_postgres-1       | 2026-05-20 13:43:12.266 UTC [1] LOG:  database system is ready to accept connections
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z -  √ | Starting Server
mura_postgres_cfml-1  |    |------------------------------
mura_postgres_cfml-1  |    | Looking for server JSON file by convention: /app//server.json
mura_postgres_cfml-1  |    | webroot defaulted to location of server's JSON file: /app/
mura_postgres_cfml-1  |    | Site name - app
mura_postgres_cfml-1  |    | Webroot - /app/
mura_postgres_cfml-1  |    | Site config file - /app//server.json
mura_postgres_cfml-1  |    | Contacting ForgeBox to determine the latest & greatest version of [lu
mura_postgres_cfml-1  |    | cee 5]...  Use an exact 'cfengine' version to skip this check
mura_postgres_cfml-1  |    | OK, [lucee 5.4.8+2] it is!
mura_postgres_cfml-1  |    | Building a WAR from local jars.
mura_postgres_cfml-1  |    | Start script for shell [bash] generated at: /app/server-start.sh
mura_postgres_cfml-1  |    | Server start command:
mura_postgres_cfml-1  |    |     /opt/java/openjdk/bin/java
mura_postgres_cfml-1  |    |     -cp /usr/local/lib/CommandBox/lib/runwar-legacy-5.2.3.jar runwar.
mura_postgres_cfml-1  |    | Start /usr/local/lib/serverHome/serverInfo.jso
mura_postgres_cfml-1  |    | Dry run specified, exiting without starting server.
mura_postgres_cfml-1  |    |------------------------------
mura_postgres_cfml-1  |    | √ | Overriding server.json values from env vars
mura_postgres_cfml-1  |    |   |----------------------------------------------------------
mura_postgres_cfml-1  |    |   | Overridding [APP.SERVERHOMEDIRECTORY] with OS environment variable [B
mura_postgres_cfml-1  |    |   | OX_SERVER_APP_SERVERHOMEDIRECTORY
mura_postgres_cfml-1  |    |   | Overridding [APP.CFENGINE] with OS environment variable [BOX_SERVER_A
mura_postgres_cfml-1  |    |   | PP_CFENGINE
mura_postgres_cfml-1  |    |   | Overridding [WEB.REWRITES.ENABLE] with OS environment variable [BOX_S
mura_postgres_cfml-1  |    |   | ERVER_WEB_REWRITES_ENABLE
mura_postgres_cfml-1  |    |   |----------------------------------------------------------
mura_postgres_cfml-1  |    | √ | Setting site [app] Profile to [production]
mura_postgres_cfml-1  |    |   |---------------------------------------------------------
mura_postgres_cfml-1  |    |   | Profile set from secure by default
mura_postgres_cfml-1  |    |   | Block CF Admin external
mura_postgres_cfml-1  |    |   | Block Sensitive Paths enabled
mura_postgres_cfml-1  |    |   | Block Flash Remoting enabled
mura_postgres_cfml-1  |    |   | Directory Browsing disabled
mura_postgres_cfml-1  |    |   | File Caching enabled
mura_postgres_cfml-1  |    |   |---------------------------------------------------------
mura_postgres_cfml-1  |    | √ | Loading CFConfig into server
mura_postgres_cfml-1  |    |   |-------------------------------------------
mura_postgres_cfml-1  |    |   | Found OS environment variable [CFCONFIG_ADMINPASSWORD]
mura_postgres_cfml-1  |    |   | Importing into [luceeserver]...
mura_postgres_cfml-1  |    |   | [ADMINPASSWORD] set.
mura_postgres_cfml-1  |    |   | No Web context admin password found. Setting your admin password to t
mura_postgres_cfml-1  |    |   | he same as your Server context password
mura_postgres_cfml-1  |    |   | [adminPassword] set.
mura_postgres_cfml-1  |    |   |-------------------------------------------
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z - Starting server using generated script: /usr/local/bin/startup.sh
mura_postgres_cfml-1  | NOTE: Picked up JDK_JAVA_OPTIONS:  --add-opens=java.base/sun.nio.ch=ALL-UNNAMED --add-opens=java.base/sun.nio.cs=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.annotation=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED --add-opens=java.base/java.lang.module=ALL-UNNAMED --add-opens=java.base/java.lang.ref=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.math=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.net.spi=ALL-UNNAMED --add-opens=java.base/java.nio=ALL-UNNAMED --add-opens=java.base/java.nio.channels=ALL-UNNAMED --add-opens=java.base/java.nio.channels.spi=ALL-UNNAMED --add-opens=java.base/java.nio.charset=ALL-UNNAMED --add-opens=java.base/java.nio.charset.spi=ALL-UNNAMED --add-opens=java.base/java.nio.file=ALL-UNNAMED --add-opens=java.base/java.nio.file.attribute=ALL-UNNAMED --add-opens=java.base/java.nio.file.spi=ALL-UNNAMED --add-opens=java.base/java.security=ALL-UNNAMED --add-opens=java.base/java.security.cert=ALL-UNNAMED --add-opens=java.base/java.security.interfaces=ALL-UNNAMED --add-opens=java.base/java.security.spec=ALL-UNNAMED --add-opens=java.base/java.text=ALL-UNNAMED --add-opens=java.base/java.text.spi=ALL-UNNAMED --add-opens=java.base/java.time=ALL-UNNAMED --add-opens=java.base/java.time.chrono=ALL-UNNAMED --add-opens=java.base/java.time.format=ALL-UNNAMED --add-opens=java.base/java.time.temporal=ALL-UNNAMED --add-opens=java.base/java.time.zone=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.util.concurrent=ALL-UNNAMED --add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED --add-opens=java.base/java.util.concurrent.locks=ALL-UNNAMED --add-opens=java.base/java.util.function=ALL-UNNAMED --add-opens=java.base/java.util.jar=ALL-UNNAMED --add-opens=java.base/java.util.regex=ALL-UNNAMED --add-opens=java.base/java.util.spi=ALL-UNNAMED --add-opens=java.base/java.util.stream=ALL-UNNAMED --add-opens=java.base/java.util.zip=ALL-UNNAMED --add-opens=java.base/javax.crypto=ALL-UNNAMED --add-opens=java.base/javax.crypto.interfaces=ALL-UNNAMED --add-opens=java.base/javax.crypto.spec=ALL-UNNAMED --add-opens=java.base/javax.net=ALL-UNNAMED --add-opens=java.base/javax.net.ssl=ALL-UNNAMED --add-opens=java.base/javax.security.auth=ALL-UNNAMED --add-opens=java.base/javax.security.auth.callback=ALL-UNNAMED --add-opens=java.base/javax.security.auth.login=ALL-UNNAMED --add-opens=java.base/javax.security.auth.spi=ALL-UNNAMED --add-opens=java.base/javax.security.auth.x500=ALL-UNNAMED --add-opens=java.base/javax.security.cert=ALL-UNNAMED --add-opens=java.base/sun.net.www.protocol.https=ALL-UNNAMED --add-opens=java.desktop/com.sun.java.swing.plaf.motif=ALL-UNNAMED --add-opens=java.desktop/com.sun.java.swing.plaf.windows=ALL-UNNAMED --add-opens=java.desktop/javax.swing.plaf.nimbus=ALL-UNNAMED --add-opens=java.desktop/sun.java2d=ALL-UNNAMED --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED --add-opens=java.base/sun.security.rsa=ALL-UNNAMED --add-opens=java.base/sun.security.pkcs=ALL-UNNAMED --add-opens=java.base/sun.security.x509=ALL-UNNAMED --add-opens=java.base/sun.security.util=ALL-UNNAMED --add-opens=java.base/sun.util.cldr=ALL-UNNAMED --add-opens=java.base/sun.util=ALL-UNNAMED --add-opens=java.base/sun.util.locale.provider=ALL-UNNAMED --add-opens=java.management/sun.management=ALL-UNNAMED  --add-exports=java.desktop/sun.java2d=ALL-UNNAMED --add-exports=java.base/sun.util=ALL-UNNAMED
mura_postgres_cfml-1  | Picked up JAVA_TOOL_OPTIONS: -Djava.util.logging.config.file=/usr/local/lib/build/resources/text.logging.properties
mura_postgres_cfml-1  | WARNING: package com.sun.java.swing.plaf.windows not in java.desktop
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - ******************************************************************************
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - Starting Runwar
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -   - Runwar Version: 5.2.3
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -   - Java Version: 11.0.30+7 (Eclipse Adoptium)
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -   - Java Home: /opt/java/openjdk
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - ******************************************************************************
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - Listeners:
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -   - Binding HTTP on 0.0.0.0:8080
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - ******************************************************************************
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - Configuring Servlet
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -   Found WEB-INF: '/usr/local/lib/serverHome/WEB-INF'
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - ******************************************************************************
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server - Creating deployment [default]
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:17Z runwar.server -     Web Root: /app
mura_postgres_cfml-1  | WARNING: An illegal reflective access operation has occurred
mura_postgres_cfml-1  | WARNING: Illegal reflective access by lucee.commons.lang.ClassUtil (jar:/usr/local/lib/serverHome/WEB-INF/lucee-server/patches/5.4.8.2.lco) to constructor com.sun.org.apache.xerces.internal.jaxp.DocumentBuilderFactoryImpl()
mura_postgres_cfml-1  | WARNING: Please consider reporting this to the maintainers of lucee.commons.lang.ClassUtil
mura_postgres_cfml-1  | WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
mura_postgres_cfml-1  | WARNING: All illegal access operations will be denied in a future release
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:19Z runwar.server - ******************************************************************************
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:19Z runwar.server - Starting 'stop' listener thread - Host: 127.0.0.1 - Socket: 38789
mura_postgres_cfml-1  | [INFO] 2026-05-20T13:43:19Z runwar.server - Server is up - stop-port:38789 PID:7 version 5.2.3
mura_postgres-1       | 2026-05-20 13:43:32.111 UTC [69] ERROR:  relation "tcontent" does not exist at character 40
mura_postgres-1       | 2026-05-20 13:43:32.111 UTC [69] STATEMENT:  SELECT COUNT( contentid )
mura_postgres-1       |                 FROM tcontent
mura_postgres-1       | 2026-05-20 13:43:56.350 UTC [69] ERROR:  column "urltitle" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.350 UTC [69] HINT:  Perhaps you meant to reference the column "tcontent.title".
mura_postgres-1       | 2026-05-20 13:43:56.350 UTC [69] STATEMENT:  select urltitle from tcontent  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.353 UTC [69] ERROR:  column "domainalias" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.353 UTC [69] STATEMENT:  select domainAlias from tsettings  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.370 UTC [69] ERROR:  relation "tuserremotesessions" does not exist at character 42
mura_postgres-1       | 2026-05-20 13:43:56.370 UTC [69] STATEMENT:  select userID as CheckIfTableExists from tuserremotesessions where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.377 UTC [69] ERROR:  column "remoteid" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.377 UTC [69] STATEMENT:  select remoteID from tclassextenddatauseractivity  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.378 UTC [69] ERROR:  column "remoteid" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.378 UTC [69] STATEMENT:  select remoteID from tclassextenddata where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.391 UTC [69] ERROR:  column "remoteid" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.391 UTC [69] STATEMENT:  select remoteID from tcontentfeeds  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.392 UTC [69] ERROR:  column "remoteid" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.392 UTC [69] STATEMENT:  select remoteID from tcontentcategories  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.393 UTC [69] ERROR:  column "container" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.393 UTC [69] STATEMENT:  select container from tclassextendsets  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.396 UTC [69] ERROR:  column "tablist" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.396 UTC [69] STATEMENT:  select tablist from tusers  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.401 UTC [69] ERROR:  column "parentid" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.401 UTC [69] STATEMENT:  select parentid from tcontentcomments  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.403 UTC [69] ERROR:  column "tagline" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.403 UTC [69] STATEMENT:  select tagline from tsettings  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.404 UTC [69] ERROR:  column "params" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.404 UTC [69] STATEMENT:  select params from tcontentobjects  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.407 UTC [69] ERROR:  column "remotepubdate" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.407 UTC [69] STATEMENT:  select remotePubDate from tcontentcategories  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.408 UTC [69] ERROR:  column "remotepubdate" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.408 UTC [69] STATEMENT:  select remotePubDate from tcontentfeeds  where 0=1
mura_postgres-1       | 2026-05-20 13:43:56.421 UTC [69] ERROR:  column "iconclass" does not exist at character 28
mura_postgres-1       | 2026-05-20 13:43:56.421 UTC [69] STATEMENT:  select siteID,type,subtype,iconclass from tclassextend
mura_postgres-1       | 2026-05-20 13:43:56.424 UTC [69] ERROR:  column "iconclass" does not exist at character 28
mura_postgres-1       | 2026-05-20 13:43:56.424 UTC [69] STATEMENT:  select siteID,type,subtype,iconclass from tclassextend
mura_postgres-1       | 2026-05-20 13:43:56.443 UTC [69] ERROR:  column "urltitle" does not exist at character 8
mura_postgres-1       | 2026-05-20 13:43:56.443 UTC [69] STATEMENT:  select urltitle from tcontentcategories  where 0=1
mura_postgres-1       | 2026-05-20 14:37:44.470 UTC [62] LOG:  checkpoint starting: time
mura_postgres-1       | 2026-05-20 15:05:15.539 UTC [62] LOG:  checkpoint complete: wrote 351 buffers (2.1%); 0 WAL file(s) added, 0 removed, 0 recycled; write=1651.051 s, sync=0.015 s, total=1651.069 s; sync files=461, longest=0.003 s, average=0.001 s; distance=2670 kB, estimate=2670 kB; lsn=0/1BA4580, redo lsn=0/1BA44F0
```

## Browse

Go to:

- http://localhost:8080

You should see a "Default" web page and text such as "Masa CMS's rich feature set and powerful extensibility…"

## Browse admin

Go to:

- http:/localhost:8080/admin

You can login with the following credentials:

- Username: admin
- Password: admin
