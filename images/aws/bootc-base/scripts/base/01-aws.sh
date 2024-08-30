#!/usr/bin/env bash

set -euox pipefail

echo "Installing AWS CLI..."
ARCH=$(uname -m)

curl -Lo /tmp/awscli https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip
unzip -q /tmp/awscli -d /tmp/

/tmp/aws/install --bin-dir /usr/bin --install-dir /usr/lib/aws-cli


echo "Installing ECR Credential Helper..."
ARCH=$(uname -m)
case "$ARCH" in
  aarch64) ARCH="arm64" ;;
  x86_64) ARCH="amd64" ;;
esac

LATEST_TAG=$(curl -LsSf https://api.github.com/repos/awslabs/amazon-ecr-credential-helper/releases/latest | jq -r ".tag_name" | cut -c 2-)

curl -LsSf -o /usr/bin/docker-credential-ecr-login https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/${LATEST_TAG}/linux-${ARCH}/docker-credential-ecr-login
chmod +x /usr/bin/docker-credential-ecr-login


echo "Installing EC2 Services and Helpers"
ARCH=$(uname -m)
case "$ARCH" in
  aarch64) ARCH="arm64" ;;
  x86_64) ARCH="amd64" ;;
esac
dnf install -y \
  https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_${ARCH}/amazon-ssm-agent.rpm \
  ec2-instance-connect \
  amazon-ec2-utils \
  cloud-init

# Enable services to start on boot
systemctl enable amazon-ssm-agent
