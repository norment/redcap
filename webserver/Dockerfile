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