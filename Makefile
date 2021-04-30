all: webserver_redcap.tar.gz phpmyadmin.tar.gz mysql_redcap.tar.gz

# syntax for 'docker build' command:
# build -f <Dockerfile> <root_folder> -t <image_name>
# 
# helpful command to start container & go over files within container
# docker run -it webserver_redcap /bin/bash

webserver_redcap.tar.gz: webserver/Dockerfile
	docker build -f webserver/Dockerfile webserver -t webserver_redcap
	docker save webserver_redcap:latest | gzip > webserver_redcap.tar.gz

phpmyadmin.tar.gz: phpmyadmin/Dockerfile
	docker build -f phpmyadmin/Dockerfile phpmyadmin -t phpmyadmin
	docker save phpmyadmin:latest | gzip > phpmyadmin.tar.gz

mysql_redcap.tar.gz: mysql/Dockerfile
	docker build -f mysql/Dockerfile mysql -t mysql_redcap
	docker save mysql_redcap:latest | gzip > mysql_redcap.tar.gz

