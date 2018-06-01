#!/usr/bin/env bash

script_path=$(dirname $0)
cd $script_path

if [ ! -e ./.certs ]; then
  mkdir ./.certs
fi

./genlocalcrt.sh ./.certs

docker network create proxy
docker-compose up -d
