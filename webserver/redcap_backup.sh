source /etc/profile.d/docker.sh
DATE=`date +"%d_%b_%Y_%H%M"`
SQLFILE=/tsd/pXX/data/durable/database/redcap_backup/database_${DATE}
DATABASE=redcap
USER=root
PASSWORD=norment123

echo $SQLFILE >> /tsd/pXX/data/durable/database/redcap_backup/log.log

docker exec redcap_database_1 /usr/bin/mysqldump --single-transaction -u ${USER} -p${PASSWORD} ${DATABASE} > ${SQLFILE}.sql

