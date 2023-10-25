<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents 

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Import files to TSD](#import-files-to-tsd)
- [Load and start docker images](#load-and-start-docker-images)
- [Edit REDcap configuration files](#edit-redcap-configuration-files)
- [Copy redcap software into docker volume](#copy-redcap-software-into-docker-volume)
- [First-time Configuration](#first-time-configuration)
- [Registering TSD users through LDAP](#registering-tsd-users-through-ldap)
- [Configure SQL stabase backups](#configure-sql-stabase-backups)
- [Upgrade REDCap to newer version](#upgrade-redcap-to-newer-version)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Local Testing](#local-testing)
- [Docker Volumes](#docker-volumes)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Getting Started 

This [repository](https://github.com/norment/redcap) contains [REDCap](https://www.project-redcap.org/) deployment procedures customized for [TSD environment](https://www.uio.no/tjenester/it/forskning/sensitiv/).

This README covers Docker-based REDCap deployment procedure for a [TSD](https://www.uio.no/english/services/it/research/sensitive-data/index.html) project. Optionally, you could first test REDcap deployment on your local machine, as described [here](#local-testing). For additional details see [CONTRIBUTING.md](CONTRIBUTING.md).

If you're new to [Docker](https://www.docker.com/), check  information [here](https://docs.docker.com/get-started/).
You may also want to register to be a member of [REDCap community](https://redcap.vanderbilt.edu/community/) which provides access to additional documentation and resources beyond what's available on public REDCap's website (https://www.project-redcap.org/).

## Prerequisites

You need to have a “pXX-service” Linux VM that supports `docker` and `docker-compose` in the TSD project where you want to deploy the REDCap. To find out if such machine is available try logging in to the “pXX-service-l” machine using ssh or putty, and execute `docker ps` and `docker-compose`. If this does not work, report this to [TSD drift](tsd-drift@usit.uio.no). If the “pXX-service-l“ machine itself is not available, request to create a Linux service VM for your TSD project (suggested specs: 4 GB RAM, 2 VCPUs, and 100 GB storage), and to install `docker` and `docker-compose` on that machine.

To deploy REDCap, you need its source code requiring a valid end-user license [agreement](https://projectredcap.org/partners/join/) between Vanderbilt University and your organization. We're in process of applying for a broad UiO-wide REDcap license, but this is not finalized as of Oct 2023. If your organization already has such an agreement, download the latest REDCap software zip file from [here](https://redcap.vanderbilt.edu/community/custom/download.php) or apply for one. Consider choosing a Long-Term Support (“LTS”) version. (With TSD p33/p697 access, see also `/tsd/pXX/data/durable/database/redcap`).

## Import files to TSD

Download docker images (`mysql.tar.gz`, `phpmyadmin.tar.gz` and `webserver.tar.gz` files) from [here](dockerimages) to your local machine.

Also download the following files (also to your local machine):
* [docker-compose.yml](docker-compose.yml)
* [database.php](webserver/database.php)
* [php_uploads.ini](webserver/php_uploads.ini)
* [ldap_config.php](webserver/ldap_config.php)
* [redcap_backup.sh](webserver/redcap_backup.sh)

Also make sure you have downloaded REDCap software zip file (e.g. ``redcap11.3.3.zip`` file).

Use https://data.tsd.usit.no to import all the files listed above to your TSD project.

Login to TSD, and connect to the pXX-service-l machine (`ssh pXX-service-l.tsd.usit.no`). Then execute the following in the terminal:
```bash
export REDCAPDIR=/tsd/pXX/data/durable/database/redcap
mkdir $REDCAPDIR && cd $REDCAPDIR
```

Move all imported files into `$REDCAPDIR`.

Optional: delete all the dangling images and containers (`docker system prune -a`).

## Load and start docker images

Load the docker images
```bash
docker load < webserver.tar.gz
docker load < phpmyadmin.tar.gz
docker load < mysql.tar.gz
```

and run
```bash
docker-compose up
```

In case `docker-compose up` fails, change the following variables 
```bash
export DOCKER_CLIENT_TIMEOUT=600 # or use a higher value
export COMPOSE_HTTP_TIMEOUT=600
docker-compose up -d # to start the process in the background
```

The logs can be checked using the command `docker-compose logs` or to see the tail `docker-compose logs --tail 10`.

## Edit REDcap configuration files

Extract the REDCap software zip file file  in `$REDCAPDIR`.
Update configuration as follows:

- the `database.php` file located [here](webserver/database.php) and place it in the REDCap directory or edit the file manually to adapt the MySQL configuration of REDCap by changing lines 6–19 to:
  ```sql
  $hostname   = 'database';
  $db         = 'redcap';
  $username   = 'norment_admin';
  $password   = 'norment123';
  ```

- enable the TSD-specific LDAP authentication by adapting the LDAP connection information under `$REDCAPDIR/redcap/webtools2/ldap/ldap_config.php`, or use [this](webserver/ldap_config.php) file directly:
  ```sql
  $GLOBALS['ldapdsn'] = array( 
    'url'           => 'ldap://tsd-dc01.tsd.usit.no',
    'port'          => 389,
    'version'       => 3,
    'referrals'     => false,
    'basedn'        => 'dc=tsd,dc=usit,dc=no',
    'binddn'        => $_POST['username'].'@tsd.usit.no',
    'bindpw'        => $_POST['password'],
    'userattr'      => 'samAccountName',
    'userfilter'    => '(samAccountName='.$_POST['username'].')' 
  );
  ```

Make the REDCap directory executable and accessible to all users:
```bash
chmod -R 777 ./redcap
```

## Copy redcap software into docker volume

Copy the REDCap directory into the web server volume via

```bash
docker cp $REDCAPDIR/redcap redcap_webserver_1:/var/www/html/
```

The name of the volume should be `redcap_webserver_1`. If that is not the case, please adapt the name in the command (all docker volumes can be listed via `docker volume ls`).

See [here](#docker-volumes) for brief information about docker volumes and how we used them for REDcap deployment.

##  First-time Configuration

From a browser, log in to phpMyAdmin (`pXX-service-l.tsd.usit.no:9000`) with the root user credentials (root, norment123) and navigate to the SQL tab. Paste
```sql
CREATE DATABASE IF NOT EXISTS `redcap`;
CREATE USER 'norment_admin'@'%' IDENTIFIED WITH mysql_native_password BY 'norment123';
GRANT SELECT, INSERT, UPDATE, DELETE ON `redcap`.* TO 'norment_admin'@'%';
```

and execute the SQL command (press `Go`) to create a respective user. Refresh the page. If the connection to the database does not succeed, the problem is likely in `database.php`. 

Having the database configured, access REDCap (`pXX-service-l.tsd.usit.no:8000/redcap/install.php`), and follow the instructions for the REDCap configuration. The URL can be modified, and additional configurations such as date and time format can be made. Eventually, press `Generate SQL install script` and paste the prompted lines in the SQL command line (through phpMyAdmin as above).

Some checks likely fail because of a lack of internet access, while other things can be resolved (e.g., `cron jobs`) after login (more details further down).

If the URL was not altered, a REDCap instance should now be accessible via `pXX-service-l.tsd.usit.no:8000`. The instance can be stopped by terminating the run dockers via

```bash
docker-compose down
```

## Registering TSD users through LDAP

Having set the TSD-specific settings in the `ldap_config.php` (see [here](#edit-redcap-configuration-files)), configure the authentication method in REDCap by navigating to `Control Center` &rarr; `Security & Authentication`, and changing the authentication method to `LDAP`. Confirm by clicking on `Save Changes` at the bottom of the page. 

Reload the page and log in with your TSD-project credentials to add your LDAP user to the REDCap records.

If the LDAP authentication does not work, consider changing the authentication back to `public (None)` by adding the first admin user (`site_admin`; already logged in using LDAP). This can be done by opening the phpMyAdmin page and executing
```sql
UPDATE redcap_config SET value='none' WHERE field_name='auth_meth_global'
```
in the SQL tab.

Once adding TSD user credentials works, you can give certain users admin rights via `Control Center` &rarr; `Administrator Privileges`.

## Configure SQL stabase backups

Daily backups are scheduled by `cronjob` on our p33 and p697 service VMs. Please check if that is the case for your project. To create a `cronjob` on a pXX-service-l, run:
```bash
crontab -e 
```

and add the following line
``` bash
12 0 * * * /tsd/pXX/data/durable/database/redcap_backup/redcap_backup.sh > /tmp/cronjob.log 2>&1
```

The backup script is located [here](webserver/redcap_backup.sh) (or for p33/p697 `/tsd/pXXX/durable/database/redcap_backup/redcap_backup.sh`). Please adapt the project number in the script. To restore the REDCap database using the `mysqldump` utility (after a new install; remember that the installed version of the REDcap must presicely match the version used to generate SQL backup!):
```bash
cat SQL_BACKUP_FILE | docker exec -i DB_CONTAINER /usr/bin/mysql -u root --password=norment123 redcap
```

And restart the REDCap database container via
```bash
docker restart redcap_database_1
```

## Upgrade REDCap to newer version

Following the steps for the REDCap installation, version-specific entries were added to the MySQL database via phpMyAdmin. Hence, it is not possible to just replace the files in the webserver volume. 

To properly upgrade REDCap, note down the current version of the REDCap instance (it will be needed later). Download an "Upgrade Package" of choice from [here](https://redcap.vanderbilt.edu/community/custom/download.php) (see also the "Upgrade Instructions.txt" in the downloaded zip file). Import the `redcapX.X.X_upgrade.zip` file to `$REDCAPDIR` and unzip the archive. Copy the version-specific directory to the webserver volume via:
```bash
docker cp $REDCAPDIR/redcap/* redcap_webserver_1:/var/www/html/redcap/
```

Perform the upgrade via a browser: 
```html
p697-service-l:8000/redcap/redcap_vX.X.X/upgrade.php
```

and follow the displayed steps. If the update was successful, remove the prior REDCap version via
``` bash
docker exec redcap_webserver_1 rm -rf ./redcap/redcap_vX.X.X
```

## Frequently Asked Questions

If REDCap is not loading through the browser, restart the docker daemon service on pXX-service-l
```bash
sudo systemctl restart docker-rootless.service
```

Useful command, connecting to the docker containers (good to know but should not be needed):
```bash
docker exec -it <<container name>> /bin/bash
```
Need to adapt the file upload and memory limit settings? The web server docker container contains the php configuration file needed to update the file upload size settings. Change the variables in the `php.ini` file (inside web server container `/usr/local/etc/php`) `post_max_size` and `upload_max_filesize` to a higher value (currently set to 10 GB). Set the value of the variable `memory_limit` to 10 GB. [Here](webserver/php_uploads.ini) are the settings we used.

If you have trouble using `vim` execute the `“set mouse=”` command within the container as described [here](https://vi.stackexchange.com/questions/18001/why-cant-i-paste-commands-into-vi) and restart the docker web server with `docker restart dockername`.

## Local Testing

To try REDCap on your local machine (given the cloned repository and the `.tar.gz` files), follow the steps under [REDCap Deployment](#redcap-deployment), but with differing addresses:
  - phpMyAdmin: http://localhost:9000
  - REDCap: http://localhost:8000

## Docker Volumes

As defined in [docker-compose.yml](docker-compose.yml) file, we use two volumes for REDcap deployment. 
First volume, ``redcap_mysql_datavolume``, is responsible for storing SQL database files. Second volume, ``redcap_webserver``, stores REDcap software files, which you upgrade in order to move to a newer version of REDcap software.
These docker volumes are [persistent](https://docs.docker.com/storage/volumes/), in a sense that after ``docker-compose down`` the volumes are kept, and the same volums are used after docker containers are re-started with ``docker-compose up``.

These volumes should be locally located under

```bash
/var/lib/user/containers/.local/share/docker/volumes/
```

The exact names can be determined via 
```bash
docker volume ls 
```

and their respective mount points via
```bash
docker inspect volume_name
```

In the case of the MySQL database, it should be (w.r.t. the path above) `./redcap_redcap_database/_data`.
