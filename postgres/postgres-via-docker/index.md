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
