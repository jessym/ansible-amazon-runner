#!/usr/bin/env bash

###
### Setup python
###
if ! command -v python > /dev/null; then
  echo "Please install Python"
  exit 1
fi
if [[ ! -d ".venv" ]]; then
  python -m venv .venv
fi
source .venv/bin/activate
pip install -r requirements.txt -q -q

###
### Available playbooks
###
available_playbooks=()
while IFS= read -r playbook; do
  available_playbooks+=("${playbook#playbook_}")
done < <(find . -iname 'playbook_*.yaml' -type f -maxdepth 1 -exec basename {} .yaml \;)

###
### Helper functions
###
function stdout {
  echo -e "$1"
}
function stdbld {
  echo -e "\033[1m$1\033[0m"
}
function is_playbook {
  needle="$1"
  for item in "${available_playbooks[@]}"; do
    if [ "$item" == "$needle" ]; then
        echo "true"
        return
    fi
  done
  echo "false"
}
function run_playbook {
  command="$1"
  source ./awsconfig
  ansible-playbook "playbook_$command.yaml"
}
function usage {
  stdbld "Usage:"
  for playbook in "${available_playbooks[@]}"; do
      stdout "   $0 $playbook"
  done
  stdout "   $0 connect [port?]"
  exit 1
}

###
### Command argument
###
command="$1"

###
### Run playbook
###
if [[ "$(is_playbook "$command")" == "true" ]]; then
  run_playbook "$command"
  if [[ "$command" == "provision" ]]; then
    stdbld "The server has been provisioned - would you like to connect?"
    stdout "(Optionally enter a port number followed by Enter, or kill this script with Ctrl-C)"
    read -r port
    ./runner.sh connect "$port"
  fi
  exit 0
fi

###
### Connect via SSH
###
if [[ "$command" == "connect" ]]; then
  port="$2"
  username=$(cat .config/username.txt)
  ip_address=$(cat .config/ip_address.txt)
  private_key=".config/private_key.pem"

  ssh_tunnel_arg=""
  if [[ -n "$port" ]]; then
    ssh_tunnel_arg=" -L ${port}:localhost:${port}"
  fi

  ssh \
    -i $private_key \
    -o "StrictHostKeyChecking=no" \
    -o "UserKnownHostsFile=/dev/null" \
    $ssh_tunnel_arg \
    $username@$ip_address 

  stdout "###"
  stdout "###"
  stdout "### $(stdbld "Detected the end of SSH session; press ENTER to terminate the Amazon instance")"
  stdout "###"
  stdout "### Or, press Ctrl+C to keep the instance running, and exit it manually via the \"$0 terminate\" command"
  stdout "### (💰 keep in mind, though, that it costs money to keep running 💰)"
  stdout "###"
  stdout "###"
  read -r
  ./runner.sh terminate
  exit 0
fi

###
### Unknown command
###
usage
