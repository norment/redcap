# source /etc/profile.d/docker.sh
DATE=`date +"%d_%b_%Y_%H%M"`
SQLFILE=database_${DATE}
USER=root

echo $SQLFILE >> /backup/log.log

/usr/bin/mysqldump --host=database --protocol=tcp --single-transaction -u ${USER} -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} | gzip -9 -c > /backup/${SQLFILE}.sql.gz
