#!/usr/bin/env bash

script_path=$(dirname $0)
cd $script_path

if [ ! -e ./.certs ]; then
  mkdir ./.certs
fi

./genlocalcrt.sh ./.certs

if [ -z "$(docker network ls | fgrep -i proxy)" ]; then
  docker network create proxy
fi
docker-compose up -d
