#!/bin/bash
# This is only required to install mcrypt in php versions < 5.4 on CentOS
# Mcrypt is a common dependency for 5.5+ apps, so it is installed by default with those scripts
# Ensure you include in provisioning AFTER php.sh

echo "Installing Mcrypt php extension"

#install EPEL repo
if [ ! -f /etc/yum.repos.d/epel.repo ]; then
    sudo yum install epel-release -y
fi

sudo yum install libmcrypt-devel -y
sudo yum install -y php-mcrypt --enablerepo=epel

echo "Restarting Apache"
systemctl restart httpd.service

echo "Mcrypt installed"
