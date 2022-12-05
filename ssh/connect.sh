#!/usr/bin/env bash

cd "$(dirname "$0")"
username=$(cat username.txt)
ip_address=$(cat ip_address.txt)
private_key="./private_key.pem"

ssh_tunnel_arg=""
for port in $(echo $1 | sed "s/,/ /g")
do
  ssh_tunnel_arg="${ssh_tunnel_arg} -L ${port}:localhost:${port}"
done

ssh \
  -i $private_key \
  -o "StrictHostKeyChecking=no" \
  -o "UserKnownHostsFile=/dev/null" \
  $ssh_tunnel_arg \
  $username@$ip_address 
