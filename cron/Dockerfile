FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron mysql-client nano

COPY redcap_backup.sh /etc/cron.d/redcap_backup.sh
COPY cronjob.sh /etc/cron.d/cronjob.sh
RUN chmod 777 /etc/cron.d/redcap_backup.sh
RUN chmod 0644 /etc/cron.d/cronjob.sh

RUN crontab /etc/cron.d/cronjob.sh

COPY startup.sh .
RUN chmod 777 ./startup.sh
CMD ["/bin/bash","-c","./startup.sh"]
