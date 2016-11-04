#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql -uroot -e "CREATE USER 'sm'@'%' IDENTIFIED BY '123456'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'sm'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown
