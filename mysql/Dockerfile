FROM mysql:latest
RUN echo $'[mysqld]\ninnodb_buffer_pool_size=4G\nmax_allowed_packet=1G\nsort_buffer_size=2M\nread_rnd_buffer_size=1M' >> /etc/my.cnf
