FROM php:7.3-apache
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# https://serverfault.com/questions/772227/chmod-not-working-correctly-in-docker
COPY redcap /tmp/redcap
RUN mv /tmp/redcap /var/www/html && chmod -R 777 /var/www/html/redcap
