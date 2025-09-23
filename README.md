# Install in Podman

## Create Volumes

### alloy (config)

```bash
podman volume create alloy.conf
```

## Run Container

```bash
podman run \
  -v alloy.conf:/etc/alloy:z \
  -p 12345:12345 \
  docker.io/grafana/alloy:latest \
    run --server.http.listen-addr=0.0.0.0:12345 --storage.path=/var/lib/alloy/data \
    /etc/alloy/config.alloy
```