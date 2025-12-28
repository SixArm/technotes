# PostgreSQL via Docker

https://www.dbvis.com/thetable/how-to-set-up-postgres-using-docker/

```sh
docker pull postgres
docker volume create postgres_data
docker run \
	--name postgres_container \
	--env POSTGRES_PASSWORD=secret \
	--publish 5432:5432 \
	--volume postgres_data:/var/lib/postgresql/data postgres \
	--detach
docker ps
psql --host=localhost --username=postgres --password
```

## Upgrade

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
