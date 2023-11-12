# Ansible Amazon Runner

This project makes it easy to spin up a temporary Linux development machine on Amazon.

It uses Ansible to create an EC2 instance and orchestrate its provisioning, by

- installing Docker
- installing Java and Node

## Requirements

- Python
- An AWS credentials file in CSV format

## Usage

You can interact with this project via the `runner.sh` script.

```bash
# Print the usage instructions
./runner.sh

# Provision a new Amazon EC2 instance
./runner.sh provision

# Connect to an already provisioned instance (useful if you need multiple terminals)
# Optionally, specify a forwarding port number (for SSH tunneling)
./runner.sh connect [port?]

# Terminate and clean up the Amazon EC2 instance
./runner.sh terminate
```

## AWS Credentials

Paste an AWS `*_accessKeys.csv` credentials file at the root of this project (it will be .gitignored).

Here's an example of the minimal set of permissions required by this project.
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
