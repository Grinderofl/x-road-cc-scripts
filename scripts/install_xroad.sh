#!/bin/bash

# ---
# REFERENCE DATA
# 
# [UG-SS] 2.1       Reference Data (User Roles)
#   .1  Registration Officer
ugcs_2_1__1='xroad-registration-officer'
#   .2  System Administrator:
ugcs_2_1__2='xroad-system-administrator'
#   .3  Security Officer:
ugcs_2_1__3='xroad-security-officer'

# [IG-SS] 2.2       Reference Data (Installation variables)
#
# [IG-CS] 1.1       X-Road package repository
igcs1_1='https://artifactory.niis.org/xroad-release-deb'
# [IG-CS] 1.2       The repository key
igcs1_2='https://artifactory.niis.org/api/gpg/key/public'
# [IG-CS] 1.3       Account name in the user interface
igcs1_3=$xroadUsername
# [IG-CS] 1.4.0     Ports for inbound connections (from the external network to the central server)
#   .1  TCP 4001 service for authentication certificate registration
igcs1_4_1__1='4001'
#   .2  TCP 80 distribution of the global configuration
igcs1_4_1__2='80'
# [IG-CS] 1.4.1     Port for inbound connections from the management security server
igcs1_4_1_1='4002'
# [IG-CS] 1.5       Port for outbound connections (from the central server to the external network)
igcs1_5='80'
# [IG-CS] 1.6       TCP 80 HTTP between the central server and the management services' security server
#   .1  TCP 4000 user interface
igcs1_6__1='4000'
#   .2  TCP 4001 HTTPS between the central server and the management services' security server
igcs1_6__2='4001'
#   .3  TCP 4400 HTTP between central server and management services' security server
igcs1_6__3='4400'
# [IG-CS] 1.7       $internalIpAddress
# [IG-CS] 1.8       $publicIpAddress
# [IG-CS] 1.9       <by default, the server’s IP addresses and names are added to the certificate’s Distinguished Name (DN) field>
# [IG-CS] 1.10      <by default, the server’s IP addresses and names are added to the certificate’s Distinguished Name (DN) field>

echo "Beginning Installation of X-Road Central Server ..."
# Exit script on error
set -euxo pipefail

# ============================================================
# 2.4 Preparing OS

# - Create user groups
echo "Creating user groups ..."
sudo groupadd xroad-registration-officer
sudo groupadd xroad-system-administrator
sudo groupadd xroad-security-officer

# * Add a system user (reference data: 1.3) whom all roles in the user interface are granted to.
echo "Creating xroad user '$xroadUsername' and adding to groups ..."
sudo useradd -m $xroadUsername -G xroad-registration-officer xroad-system-administrator xroad-security-officer
sudo echo $xroadUsername:$xroadPassword | chpasswd


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

# TODO: Automate configuration

# Add user to roles


