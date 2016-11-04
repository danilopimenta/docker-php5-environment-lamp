FROM tutum/lamp:latest

RUN chown -R 101:101 /app

RUN apt-get update &&\
    apt-get -y install git imagemagick subversion curl apache2 php5 php5-cli libapache2-mod-php5 php5-mysql php-apc php5-gd php5-curl php5-memcached php5-mcrypt php5-mongo php5-sqlite php5-redis php5-json php5-imagick php5-xmlrpc

RUN php5enmod mcrypt
RUN a2enmod expires
RUN a2enmod headers

# config to enable .htaccess
RUN rm /etc/apache2/sites-available/000-default.conf
ADD apache_default /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid


#database configuration
ADD sql/store-db.sql /store-db.sql
ADD sql/store-adm-db.sql /store-adm-db.sql

ADD enabled_php_errors /enabled_php_errors

ADD create_mysql_user.sh create_mysql_user.sh
ADD create_db_store.sh create_db_store.sh

CMD ["/create_mysql_user.sh"]

CMD ["/create_db_store.sh"]

EXPOSE 80 3306
CMD ["/run.sh"]
