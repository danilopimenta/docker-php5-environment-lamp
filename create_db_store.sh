#!/bin/bash

cat /enabled_php_errors >> /etc/php5/apache2/php.ini
sudo service apache2 restart


/usr/bin/mysqld_safe &
sleep 5
#create store database
mysql -u root < /store-db.sql
#create loja_adm database
mysql -u root < /store-adm-db.sql
