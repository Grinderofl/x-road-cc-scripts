#!/bin/bash

echo "Beginning Installation of X-Road Central Server ..."
# Exit script on error
set -euxo pipefail
echo "Validating script parameters and environment variables ..."
# ---
# VARIABLES
# 
xroad_repo='https://artifactory.niis.org/xroad-release-deb'
xroad_repo_key='https://artifactory.niis.org/api/gpg/key/public'
xroad_username=$1
xroad_password=$2
# internal_ip=$internalIpAddress
public_ip=$3

# ============================================================
# 2.4 Preparing OS

# Create user groups
echo "Creating user groups ..."
sudo groupadd xroad-registration-officer
sudo groupadd xroad-system-administrator
sudo groupadd xroad-security-officer

# * Add a system user (reference data: 1.3) whom all roles in the user interface are granted to.
echo "Creating xroad user '$xroad_username' and adding to groups ..."
sudo useradd -m $xroad_username -G xroad-registration-officer xroad-system-administrator xroad-security-officer
sudo echo $xroad_username:$xroad_password | chpasswd


# Add UTF-8 locale for en-US and generate
echo "Adding en_US.UTF-8 locale to /etc/environment ..."
sudo echo "\nLC_ALL=en_US.UTF-8" >> /etc/environment

echo "Generating Locale..."
sudo locale-gen en_US.UTF-8

# Add repository and update packages
echo "Adding x-road repository public key to package manager ..."
curl $xroad_repo_key | sudo apt-key add -

echo "Adding x-road repository to package manager ..."
sudo apt-add-repository -y "deb $xroad_repo $(lsb_release -sc)-current main"

echo "Updating package manager packages ..."
sudo apt-get update

# Install central server
echo "Installing X-Road Central Server ..."
echo $public_ip
# TODO: Automate installation
# sudo apt-get install xroad-centralserver
# TODO: Automate configuration
# Add user to roles