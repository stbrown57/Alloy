podman run \
  -v alloy.conf:/etc/alloy:z \
  -v alloy.data:/var/lib/alloy/data:z \
  -p 12345:12345 \
  docker.io/grafana/alloy:latest \
    run --server.http.listen-addr=0.0.0.0:12345 --storage.path=/var/lib/alloy/data \
    /etc/alloy/config.alloy
