FROM mysql:8.4
RUN mkdir -p /etc/mysql/conf.d \
  && printf '%s\n' \
  '[mysqld]' \
  'innodb_buffer_pool_size=4G' \
  'max_allowed_packet=1G' \
  'sort_buffer_size=2M' \
  'read_rnd_buffer_size=1M' \
  > /etc/mysql/conf.d/redcap.cnf

COPY ./init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod 777 /docker-entrypoint-initdb.d/init.sh
