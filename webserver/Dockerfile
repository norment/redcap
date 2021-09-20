FROM php:7.3-apache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN \
    apt-get update && \
    apt-get install -y \
    libldap2-dev \ 
    vim \
    && rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN apt-get update && apt-get install -y zip

WORKDIR /var/www/html
COPY redcap11.2.5.zip /var/www/html
RUN unzip redcap11.2.5.zip && chmod -R 777 /var/www/html/redcap

RUN sed -i 's/your_mysql_host_name/db/' /var/www/html/redcap/database.php
RUN sed -i 's/your_mysql_db_name/redcap/' /var/www/html/redcap/database.php
RUN sed -i 's/your_mysql_db_username/norment_admin/' /var/www/html/redcap/database.php
RUN sed -i 's/your_mysql_db_password/norment123/' /var/www/html/redcap/database.php
RUN sed -i "s/salt = ''/salt = 'ik5jfi4c0t'/g" /var/www/html/redcap/database.php

COPY php_uploads.ini /usr/local/etc/php/conf.d/php_uploads.ini
COPY ldap_config.php /var/www/html/redcap/webtools2/ldap/ldap_config.php
