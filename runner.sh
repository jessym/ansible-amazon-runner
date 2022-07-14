#!/usr/bin/env bash

###
### Helper functions
###
function is_one_of {
    local value="$1"
    shift
    for i in "$@"; do
        if [[ "$value" == "$i" ]]; then
            echo "true"
            return 0
        fi
    done
    echo "false"
    return 1
}

###
### Determine which ansible command to run
###
command="$1"
if [ "$command" != "start" ] && [ "$command" != "connect" ] && [ "$command" != "terminate" ] && [ "$command" != "debug" ]; then
  echo "Usage: $0 [start|connect|terminate|debug]"
  exit 1
fi
requires_aws_connection=$(is_one_of "$command" "start" "terminate")
requires_local_container=$(is_one_of "$command" "start" "terminate" "debug")

###
### Read the AWS csv file
###
if [ "$requires_aws_connection" == "true" ]; then
  aws_keys_csv_file=$(find . -iname '*accessKeys.csv' -type f -maxdepth 1 | head -n 1)
  if [ ! -f "$aws_keys_csv_file" ]; then
    aws_keys_csv_file="$2"
    if [ ! -f "$aws_keys_csv_file" ]; then
      echo "Could not find an AWS csv file at the root of the project, please provide one via the CLI"
      echo "Usage: $0 [start|terminate|debug] [aws_keys_csv_file]"
      exit 1
    fi
  fi
fi

if [ "$requires_local_container" == "true" ]; then
  ###
  ### Build the ansible runner image
  ###
  docker build ./docker --platform linux/x86_64 -t ansible-amazon-runner
  docker image prune -f

  ###
  ### Start the local container
  ###
  ansible_command="ansible-playbook $command.yaml"
  if [ "$command" == "debug" ]; then
    ansible_command="bash"
  fi
  docker run \
    --rm -it \
    --volume "$(pwd)/ansible:/ansible" \
    --volume "$(pwd)/ssh:/ssh" \
    --mount "type=bind,source=$(pwd)/$aws_keys_csv_file,target=/root/.aws/keys.csv" \
    --platform linux/x86_64 \
    ansible-amazon-runner "$ansible_command"
fi

###
### Start an SSH session with the AWS instance
###
if [ "$command" == "start" ] || [ "$command" == "connect" ]; then
  ./ssh/connect.sh

  echo "###"
  echo "###"
  echo "### Detected end of SSH session. Press ENTER to terminate the Amazon instance"
  echo "###"
  echo "### Or, press Ctrl+C to keep the instance running, and exit it manually via the \"$0 terminate\" command"
  echo "### (💰 keep in mind, though, that it costs money to keep running 💰)"
  echo "###"
  echo "###"
  read -r
  ./runner.sh terminate
fi

###
### terminate the ansible runner image (if requested)
###
if [ "$command" == "terminate" ]; then
  echo "AWS instance terminated (consider manually wiping the local docker image)"
fi
