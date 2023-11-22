mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER ${MYSQL_REDCAP_USER}@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT SELECT, INSERT, UPDATE, DELETE ON ${MYSQL_DATABASE}.* TO '${MYSQL_REDCAP_USER}'@'%';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "FLUSH PRIVILEGES;"