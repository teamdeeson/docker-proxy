#!/usr/bin/env bash

set -e

script_path=$(dirname $0)
working_dir=$(pwd)
cd "$script_path/.."
repo_root=$(pwd)

clean=0
if [ "$1" == "clean" ]; then
  clean=1
fi

defaults="${script_path}/defaults"
cert_dir=.certs
if [ ! -e "${cert_dir}" ]; then
  mkdir -p "${cert_dir}"
fi

if [ ! -f "${cert_dir}/cert.cnf" ]; then
  cp "${defaults}/cert.cnf" "${cert_dir}/cert.cnf"
fi

if [ ! -f "${cert_dir}/cert.cnf.dns" ]; then
  cp "${defaults}/cert.cnf.dns" "${cert_dir}/cert.cnf.dns"
fi

local_cert="${cert_dir}/local.crt"
local_key="${cert_dir}/local.key"

if [ "${clean}" -eq 1 ]; then
  if [ -f "${local_cert}" ]; then
    unlink "${local_cert}"
  fi
  if [ -f "${local_key}" ]; then
    unlink "${local_key}"
  fi
fi

if [ -f "${local_cert}" ] && [ -f "${local_key}" ] ; then
  echo 'Certificate exists'
  exit
fi

# Generate a self-signed certificate if one is missing.
# Certificate generation steps from https://somoit.net/security/security-create-self-signed-san-certificate-openssl.
openssl=`which openssl`
$openssl req \
    -new \
    -x509 \
    -nodes \
    -sha256 \
    -days 3650 \
    -newkey rsa:2048 \
    -keyout "${local_cert}" \
    -out "${local_key}" \
    -config <(cat "${cert_dir}/cert.cnf" \
      <(cat "${cert_dir}/cert.cnf.dns"))
