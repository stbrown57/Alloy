docker run -d \
  -p 12345:12345 \
  -v "/var/log/journal:/var/log/journal" \
  -v "./config.alloy:/etc/alloy/config.alloy" \
  grafana/alloy:latest \
  --config.file=/etc/alloy/config.alloy \
  --server.http.listen-addr=0.0.0.0:12345