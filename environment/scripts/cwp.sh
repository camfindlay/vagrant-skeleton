#!/bin/bash
#Installs a fresh copy of the CWP basic recipe if not already installed.
if [ -d "/var/www/html/cwp" ]
  then
    echo "CWP basic recipe already installed"
    cd /var/www/html
  else
    cd /var/www/html
    echo "Installing CWP basic recipe and dependancies"
    composer create-project cwp/cwp-installer /var/www/html --keep-vcs --repository-url="https://packages.cwp.govt.nz"
    rm -rf /var/www/html/.git
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
cd /var/www/html/
#Configure Solr
sudo -u vagrant sake dev/tasks/Solr_Configure
sudo -u vagrant sake dev/tasks/Solr_Reindex
