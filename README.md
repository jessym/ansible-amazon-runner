# Ansible Amazon Runner

This project makes it easy to spin up a one-time Ubuntu development machine on Amazon.

It works by using Ansible inside a Docker container to create an EC2 instance and orchestrate its provisioning, by:
 - installing Docker
 - installing SDKMan
 - installing NVM
 - installing some popular versions of Java and Node

By default, the following popular dev ports are forwarded from the EC2 instance when connecting:
 - 3000
 - 4200
 - 5000
 - 8080

## Requirements

 - Docker
 - AWS credentials CSV file

## AWS credentials

Paste the AWS `*_accessKeys.csv` credentials file at the root of this project.

Here's an example of the minimal set of permissions required by this tool.
Beware that the `"Resource": "*"` part could be overly permissive, so consider restricting it.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeTags",
                "ec2:CreateKeyPair",
                "ec2:CreateTags",
                "ec2:DescribeInstanceAttribute",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:StartInstances",
                "ec2:DescribeVpcs",
                "ec2:CreateSecurityGroup",
                "ec2:DeleteSecurityGroup",
                "ec2:DescribeSubnets",
                "ec2:DescribeKeyPairs",
                "ec2:DeleteKeyPair",
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        }
    ]
}
```

## Usage

Get started by using the `runner.sh` script at the root of this project.

```bash
# Start the remote Amazon instance, and begin a CLI session
./runner.sh start

# Connect to an already running instance (useful if you need another terminal)
./runner.sh connect

# Terminate and clean up the remote Amazon instance
./runner.sh terminate
```

## Debug

```bash
# To log in and debug the local Ansible container
./runner.sh debug
```
