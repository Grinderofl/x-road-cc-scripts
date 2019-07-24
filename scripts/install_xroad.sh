#!/bin/bash

echo "Beginning Installation of X-Road Central Server ..."
# Exit script on error
set -euxo pipefail

echo "Validating script parameters and environment variables ..."
# ---
# VARIABLES
#
#
# 
# [UG-SS] 2.1       Reference Data (User Roles)
# Registration Officer
#   xroad-registration-officer
# System Administrator:
#   xroad-system-administrator
# Security Officer:
#   xroad-security-officer
#
#
# [IG-SS] 2.2       Reference Data
#
# [IG-CS] 1.1       X-Road package repository
xroad_repo='https://artifactory.niis.org/xroad-release-deb'
# [IG-CS] 1.2       The repository key
xroad_repo_key='https://artifactory.niis.org/api/gpg/key/public'
# [IG-CS] 1.3       Account name in the user interface
#                   Account password
xroad_username=$xroadUsername
xroad_password=$xroadPassword
# [IG-CS] 1.4.0     Ports for inbound connections (from the external network to the central server)
#                   TCP 4001 service for authentication certificate registration
#                   TCP 80 distribution of the global configuration
# [IG-CS] 1.4.1     Port for inbound connections from the management security server
#                   TCP 4002 management services
# [IG-CS] 1.5       Port for outbound connections (from the central server to the external network)
#                   TCP 80 software updates
# [IG-CS] 1.6       Internal network ports, the user interface port, and management service ports for the management services' security server
#                   TCP 80 HTTP between the central server and the management services' security server
#                   TCP 4000 user interface
#                   TCP 4001 HTTPS between the central server and the management services' security server
#                   TCP 4400 HTTP between central server and management services' security server
# [IG-CS] 1.7       central server internal IP address(es) and hostname(s)
# internal_ip=$internalIpAddress
# [IG-CS] 1.8       central server public IP address, NAT address
public_ip=$publicIpAddress
# [IG-CS] 1.9       by default, the server's IP addresses and names are added to the certificate's Distinguished Name (DN) field
# [IG-CS] 1.10      by default, the server's IP addresses and names are added to the certificate's Distinguished Name (DN) field



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