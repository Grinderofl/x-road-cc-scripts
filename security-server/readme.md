# Steps

```shell
sudo adduser --system xroad-security-user
sudo bash -c 'echo "LC_ALL=en_US.UTF-8" >> /etc/environment'
sudo locale-gen en_US.UTF-8
sudo apt-get install locales software-properties-common
curl https://artifactory.niis.org/api/gpg/key/public | sudo apt-key add -
sudo apt-add-repository -y "deb https://artifactory.niis.org/xroad-release-deb $(lsb_release -sc)-current main"
Ubuntu 14 only:
sudo apt-add-repository -y ppa:openjdk-r/ppa
sudo apt-add-repository -y ppa:nginx/stable
sudo apt-get update
sudo apt-get install xroad-securityserver
sudo systemctl list-units "xroad*"
sudo apt-get install xroad-addon-hwtokens
sudo service xroad-signer restart
```

z