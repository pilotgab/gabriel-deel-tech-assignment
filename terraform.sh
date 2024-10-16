#!/bin/bash

# Update the package index
sudo apt update

# Install required packages
sudo apt install -y unzip curl

# Download the AWS CLI bundle
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip the downloaded file
unzip awscliv2.zip

# Run the installer
sudo ./aws/install

# Verify the installation
aws --version

# Clean up
rm awscliv2.zip
rm -rf aws


# install terraform 

# Update the package index
sudo apt update

# Install necessary dependencies
sudo apt install -y gnupg software-properties-common curl

# Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add the HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update the package index again
sudo apt update

# Install Terraform
sudo apt install -y terraform

# Verify the installation
terraform version