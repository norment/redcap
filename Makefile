all: webserver.tar.gz phpmyadmin.tar.gz mysql.tar.gz

# syntax for 'docker build' command:
# build -f <Dockerfile> <root_folder> -t <image_name>
# 
# helpful command to start container & go over files within container
# docker run -it webserver_redcap /bin/bash

webserver.tar.gz: webserver/Dockerfile
	docker build -f webserver/Dockerfile webserver -t webserver
	docker save webserver:latest | gzip > webserver.tar.gz

phpmyadmin.tar.gz: phpmyadmin/Dockerfile
	docker build -f phpmyadmin/Dockerfile phpmyadmin -t phpmyadmin
	docker save phpmyadmin:latest | gzip > phpmyadmin.tar.gz

mysql.tar.gz: mysql/Dockerfile
	docker build -f mysql/Dockerfile mysql -t mysql
	docker save mysql:latest | gzip > mysql.tar.gz

