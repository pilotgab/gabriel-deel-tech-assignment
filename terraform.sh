#!/bin/bash

# Exit script on any error
set -e

# Function to print messages
echo_message() {
    echo -e "\n\033[1;32m$1\033[0m\n"
}

# Update and install dependencies
echo_message "Updating package list and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl unzip

# Get the latest version of Terraform
echo_message "Fetching the latest Terraform version..."
TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

# Download Terraform
echo_message "Downloading Terraform v$TERRAFORM_VERSION..."
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Unzip the binary
echo_message "Unzipping Terraform binary..."
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Move Terraform to /usr/local/bin
echo_message "Installing Terraform..."
sudo mv terraform /usr/local/bin/

# Clean up the zip file
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Verify installation
echo_message "Verifying Terraform installation..."
terraform -version

echo_message "Terraform v$TERRAFORM_VERSION has been installed successfully!"
