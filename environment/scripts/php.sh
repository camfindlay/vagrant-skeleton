#!/bin/bash

echo "Installing PHP and common modules"
rpm -ivh http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum update
yum install -y php php-common php-pdo php-mysql php-session php-dom php-gd php-fileinfo php-hash php-iconv php-mbstring php-simplexml php-tokenizer php-xml php-tidy php-mcrypt php-mcrypt

echo "Copying php.ini"
cp -f /vagrant/environment/config/php.ini /etc/php.ini

echo "Restarting Apache"
/sbin/service httpd restart

echo "PHP installed"
