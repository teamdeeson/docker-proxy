#!/usr/bin/env bash

set -e

script_path=$(dirname $0)
cd "$script_path/.."

docker ps
echo -e
df -h
echo -e
uptime
