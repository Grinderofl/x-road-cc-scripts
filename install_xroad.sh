#!/bin/bash

echo "Beginning Installation of X-Road Central Server ..."
set -euxo pipefail

# Add UTF-8 locale for en-US and generate
echo "Adding en_US.UTF-8 locale to /etc/environment ..."
sudo echo "\nLC_ALL=en_US.UTF-8" >> /etc/environment

echo "Generating Locale..."
sudo locale-gen en_US.UTF-8

# Add repository and update packages
echo "Adding x-road repository public key to package manager ..."
curl https://artifactory.niis.org/api/gpg/key/public | sudo apt-key add -

echo "Adding x-road repository to package manager ..."
sudo apt-add-repository -y "deb https://artifactory.niis.org/xroad-release-deb $(lsb_release -sc)-current main"

echo "Updating package manager packages ..."
sudo apt-get update

# Install central server
echo "Installing X-Road Central Server ..."
sudo apt-get install xroad-centralserver

