#!/usr/bin/env bash

cd "$(dirname "$0")"
username=$(cat username.txt)
ip_address=$(cat ip_address.txt)
private_key="./private_key.pem"

ssh \
  -i $private_key \
  -o "StrictHostKeyChecking=no" \
  -o "UserKnownHostsFile=/dev/null" \
  -L 3000:localhost:3000 \
  -L 4200:localhost:4200 \
  -L 5000:localhost:5000 \
  -L 8080:localhost:8080 \
  $username@$ip_address 
