FROM php:7.4-apache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN \
    apt-get update && \
    apt-get install -y \
    libldap2-dev \ 
    vim \
    libzip-dev \
    zip\
    && docker-php-ext-install zip \ 
    && rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

COPY phpinit.sh .
RUN chmod 777 ./phpinit.sh
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN /bin/bash -c ./phpinit.sh