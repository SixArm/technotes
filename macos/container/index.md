# macOS container

If you are using an Apple Silicon Mac with a compatible macOS version, you can manage lightweight Open Container Initiative (OCI) images directly through the command line.

Start the container service daemon: 

```sh
container system start
```

Pull the Debian 13 image:

```sh
container image pull debian:13
```

Run an interactive Debian 13 instance:

```sh
container run -it debian:13 bash
```

Create a persistent background development environment: 

```sh
container machine create debian13
```
