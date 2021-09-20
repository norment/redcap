source /etc/profile.d/docker.sh
PROJECT=p697
DATE=`date +"%d_%b_%Y_%H%M"`
SQLFILE=/tsd/$PROJECT/data/durable/database/redcap_backup/db_${DATE}
DATABASE=redcap
USER=root
PASSWORD=norment123

echo $SQLFILE >> /tsd/$PROJECT/data/durable/database/redcap_backup/log.log

docker exec redcap_db_1 /usr/bin/mysqldump --single-transaction -u ${USER} -p${PASSWORD} ${DATABASE} > ${SQLFILE}.sql

