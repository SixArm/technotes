# PostgreSQL 18 via Podman

<https://medium.com/@mehmetozanguven/running-postgresql-with-podman-4b71e31761b2>

Start a podman machine:

```sh
podman machine start
```

Search for postgres containers:

```sh
podman search postgres
```

Pull the official Docker library progress. We prefer being explicit about the version number 18 and operating system Trixie a.k.a. Debian 13, which we prefer for development because it tends to be easier.

```sh
podman pull docker.io/library/postgres:18-trixie
```

Verify the pull succeeded:

```sh
podman images
```

Create a directory (a.k.a. volume) that will hold postgres data. This is because data inside the container will be deleted when we remove the container’s images.

```sh
podman volume create my-postgres-docker-volume
```

Run:

```sh
podman run \
  --name my-postgres-podman-container \
  --env POSTGRES_PASSWORD=secret \
  --publish 5432:5432 \
  --volume "my-postgres-podman-volume:/var/lib/postgresql:Z"  \
  --detach \
  --tty \
  postgres:18-trixie
```

Notes:

- `--name`: Container name

- `-e, --env`: Set environment variables in container

- `-p, --publish`: Publish a container's port, or a range of ports, to the host (default []). For our PostgreSQL setup, this means any request on the port 5432 inside our computer will be redirected to the container postgres_container on the port 5432.

- `-v, --volume`:  Bind mount a volume into the container. Volume source will be on the server machine, not the client. The string on the left side of the colon is the source path i.e. on your local system; the string on the right side of the colon is the destination path i.e. inside the container. Important Note: Mount the data volume at `/var/lib/postgresql/data` and not at `/var/lib/postgresql` because mounts at the latter path WILL NOT PERSIST database data when the container is re-created.

- `:Z`: Allow the container to write to the volume, but disallow the volume to be shared with other containers. Basically this is for SELinux configuration.

- `-d, --detach`: Run container in background and print container ID

- `-t, --tty`: Allocate a pseudo-TTY for container

Caution: there is a breaking change from Podman PostgreSQL 17 to 18:

- <https://github.com/docker-library/postgres/pull/1259>

- Concretely, this changes `PGDATA` to `/var/lib/postgresql/MAJOR/docker`, which matches the pre-existing convention/standard of the `pg_ctlcluster/postgresql-common` set of commands, and frankly is what we should've done to begin with, in a classic case of Chesterton's Fence.

- This also changes the `VOLUME` to `/var/lib/postgresql`, which should be more reasonable, and make the upgrade constraints more obvious.

Troubleshooting:

```sh
podman logs <container>
```

## Usage

List containers:

```sh
podman ps
podman ps --all
```

Connect to the container:

```sh
podman exec -it my-postgres-podman-container bash
```

After connecting to the container, you can use psql:

```sh
psql -U postgres
```

Then exit psql as usual:

```psql
exit
```

Then exit the container as usual:

```sh
exit
```

Connect to the container psql from your local system:

```sh
psql --host=localhost --username=postgres --password
```

## Upgrade

IMPORTANT: These instructions are for Docker PostgreSQL, and are provided here because we expect Podman PostgreSQL to work similarily.

<https://news.onbrn.com/step-by-step-guide-upgrading-postgresql-docker-containers/>

### Step 1: Dump the database

Dump the database so we can seed the new container. We don't need to stop the container for this, as we'll be using pg_dump.

```sh
docker exec -it <container-name> pg_dump -U <username> <database-name> > db_backup.sql
```

### Step 2: Stop the container

Stop the container, so we can upgrade the PostgreSQL version.

```sh
docker compose stop <container-name>
```

### Step 3: Upgrade the PostgreSQL version

Upgrade the PostgreSQL version. Assuming you were, for example, running PostgreSQL 15 and you want to upgrade to 17, you would make the following changes to the docker-compose.yml file:

```sh
+  image: postgres:17
-  image: postgres:15
```

NOTE: If you're upgrading from <18 to >=18, you might need to also change the mounted pgdata volume as per the documentation. 

From:

```path
/var/lib/postgresql/data
```

Into:

```path
/var/lib/postgresql/<postgres-version>/docker
```

### Step 4: Start the container

Now we need to start the new container, running the new PostgreSQL version.

```sh
docker compose up -d <container-name>
```

### Step 5: Import the database

Import the database into the new container.

```sh
cat db_backup.sql | docker exec -i <container-name> psql -U <username> <database-name>
```
