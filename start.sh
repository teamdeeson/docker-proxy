#!/usr/bin/env bash

script_path=$(dirname $0)
cd $script_path

if [ ! -e ./.certs ]; then
  mkdir ./.certs
fi

./genlocalcrt.sh ./.certs

docker network create proxy
docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD/traefik.toml:/traefik.toml \
  -v $PWD/.certs:/certs \
  -p 80:80 \
  -p 443:443 \
  -l traefik.frontend.rule=Host:monitor.localhost \
  -l traefik.port=8080 \
  --network proxy \
  --name traefik \
  traefik:1.3.6-alpine --docker

#-v $PWD/acme.json:/acme.json \
