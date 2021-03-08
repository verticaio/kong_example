#!/usr/bin/env bash
sudo docker run -d --name kong-datastore \
               --restart always \
               -p 5432:5432 \
               -e "POSTGRES_USER=kong" \
               -e "POSTGRES_DB=kong" \
               -e "POSTGRES_PASSWORD=kong" \
               postgres:9.6

sleep 10
sudo systemctl restart docker
sudo docker run --rm \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=10.10.20.10" \
     -e "KONG_PG_USER=kong" \
     -e "KONG_PG_PASSWORD=kong" \
     kong:latest kong migrations bootstrap

# Kong UI
docker run -p 1337:1337 -e "TOKEN_SECRET=babak014567" -e "DB_ADAPTER=postgres" -e "DB_HOST=10.10.20.10" -e "DB_PORT=5432" -e "DB_USER=kong"  -e "DB_PASSWORD=kong" -e "DB_DATABASE=kong" -e "DB_PG_SCHEMA=kong" -e "NODE_ENV=development" --name konga pantsel/konga