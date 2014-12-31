#!/bin/bash
#Installs a fresh copy of the CWP basic recipe if not already installed.
if [ -d "/vagrant/www/cwp" ]
  then
    echo "CWP basic recipe already installed"
    cd /vagrant/www
  else
    mkdir /vagrant/www && cd /vagrant/www
    echo "Installing CWP basic recipe and dependancies"
    composer create-project cwp/cwp-installer /vagrant/www --keep-vcs --repository-url="https://packages.cwp.govt.nz"
    rm -rf /vagrant/www/.git
    echo "CWP basic recipe installed"
fi

if [ -f "framework/sake" ]
    then
        chmod +x framework/sake
        echo "sake is now executable"
        framework/sake installsake
        echo "sake in installed and global"
fi


echo "Building the database"
sake dev/build flush=1

chmod -R 0777 assets
echo "Assets folder chmodded to 777"

rm -f assets/error-*.html
echo "Pregenerated error pages removed"

#Setup local Solr
composer require silverstripe/fulltextsearch-localsolr 4.5.1.*@dev
cd fulltextsearch-localsolr/server
echo  "Starting Solr"
sudo -u vagrant nohup java -jar ./start.jar >/dev/null &
echo "Solr running" 
cd /vagrant/www
#Configure Solr
sudo -u vagrant sake dev/tasks/Solr_Configure
sudo -u vagrant sake dev/tasks/Solr_Reindex

