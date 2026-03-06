FROM php:8.4-apache
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    dpkg-dev \
    libldap2-dev \
    vim \
    libzip-dev \
    zip; \
    docker-php-ext-install mysqli zip; \
    docker-php-ext-enable mysqli; \
    LDAP_LIBDIR="$(dpkg-architecture -qDEB_HOST_MULTIARCH)"; \
    docker-php-ext-configure ldap --with-libdir="lib/${LDAP_LIBDIR}/"; \
    docker-php-ext-install ldap; \
    rm -rf /var/lib/apt/lists/*

COPY phpinit.sh .
RUN chmod 777 ./phpinit.sh
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN /bin/bash -c ./phpinit.sh
