# Lucee demo

[https://www.lucee.org](https://www.lucee.org)

Lucee is a light-weight dynamic scripting language for the JVM that enables the rapid development of simple to highly-sophisticated web applications.

### Lucee via Docker

https://docs.lucee.org/recipes/docker.html

### Pull

Pull the latest:

```sh
docker pull lucee/lucee:latest
docker run -d -p 8888:8888 lucee/lucee:latest
```

### Run

Run Lucee detached on port 8888 with an admin password:

```sh
docker run --detach --publish 8888:8888 --env LUCEE_ADMIN_PASSWORD=secret lucee/lucee:latest
```

### Access the app

Visit:

- http://localhost:8888

You should see "Welcome to your Lucee Docker Installation!"

### Access the admin

Visit:

- http://localhost:8888/lucee/admin/

You should see "Lucee Login".

Use your Lucee admin password as above.

You should see "The Server Administrator allows you to…"
