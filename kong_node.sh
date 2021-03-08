#!/usr/bin/env bash

#### Tweaks tcp stack to better request handling.
sudo cat <<EOF >>/etc/sysctl.d/95-kong-specific.conf
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 60
net.ipv4.tcp_keepalive_probes = 20
net.ipv4.tcp_max_syn_backlog = 16384
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 50000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 60
fs.file-max = 500000
EOF
sudo sysctl -p /etc/sysctl.d/95-kong-specific.conf

sleep 10
sudo systemctl restart docker

#### Runs Kong node container.
sudo docker run -d --name kong-node \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=10.10.20.10" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
     -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
     -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
     -e "KONG_ADMIN_LISTEN=0.0.0.0:8001 reuseport backlog=16384, 0.0.0.0:8444 http2 ssl reuseport backlog=16384" \
     -e "KONG_PROXY_LISTEN=0.0.0.0:8000 reuseport backlog=16384, 0.0.0.0:8443 http2 ssl reuseport backlog=16384" \
     -e "KONG_ANONYMOUS_REPORTS=off" \
     -p 8000:8000 \
     -p 8443:8443 \
     -p 8001:8001 \
     -p 8444:8444 \
     --restart always \
     --sysctl net.core.somaxconn=16384     kong:latest


curl -i http://localhost:8001/
