<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
# Table of Contents 

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Import Files to TSD](#import-files-to-tsd)
- [Load and Start Docker Images](#load-and-start-docker-images)
- [Edit REDCap Configuration Files](#edit-redcap-configuration-files)
- [Copy REDCap into Docker Volume](#copy-redcap-into-docker-volume)
- [First-time Configuration](#first-time-configuration)
- [Registering TSD users through LDAP](#registering-tsd-users-through-ldap)
- [Restore SQL database Backups](#restore-sql-database-backups)
- [Upgrade REDCap to a Newer Version](#upgrade-redcap-to-a-newer-version)
- [Multiple Instances](#multiple-instances)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Local Testing](#local-testing)
- [Docker Volumes](#docker-volumes)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Getting Started 
This [repository](https://github.com/norment/redcap) contains [REDCap](https://www.project-redcap.org/) deployment procedures customized for [TSD environment](https://www.uio.no/tjenester/it/forskning/sensitiv/).

This README covers the Podman-based REDCap deployment procedure for a [TSD](https://www.uio.no/english/services/it/research/sensitive-data/index.html) project. Optionally, you could first test REDCap deployment on your local machine, as described [here](#local-testing). For additional details see [CONTRIBUTING.md](CONTRIBUTING.md).

If you are new to [Podman](https://podman.io/), check the information [here](https://www.redhat.com/en/topics/containers/what-is-podman). As pointed out, "Podman is a powerful alternative to [Docker](https://docs.docker.com/get-started/), but the two can also work together". I.e., in case you are more familiar with Docker, most commands are easily interchangeable. 

You may also want to register to be a member of [REDCap community](https://redcap.vanderbilt.edu/community/) which provides access to additional documentation and resources beyond what's available on  REDCap's public [website](https://www.project-redcap.org).

## Prerequisites
You need to have a “pXX-podman” Linux VM that supports `podman` and `docker-compose` in the TSD project where you want to deploy the REDCap. To find out if such a machine is available try logging in to the “pXX-podman” machine using ssh or Putty, and execute `podman ps` and `docker-compose`. If this does not work, report this to the [TSD service](https://www.uio.no/english/services/it/research/sensitive-data/contact/index.html). If the “pXX-podman“ machine itself is not available, request to create a Linux service VM for your TSD project (suggested specs: 4 GB RAM, 2 VCPUs, and 100 GB storage), and install `podman` and `docker-compose` on that machine.

To deploy REDCap, you need its source code requiring a valid end-user license [agreement](https://projectredcap.org/partners/join/) between Vanderbilt University and your organization. We are in the process of applying for a broad UiO-wide REDCap license, but this is not finalized as of Nov. 2023. If your organization already has such an agreement, download the latest REDCap software zip file from [here](https://redcap.vanderbilt.edu/community/custom/download.php) or apply for one. Consider choosing a Long-Term Support (“LTS”) version. (With TSD p33/p697 access, see also `/tsd/pXX/data/durable/database/redcap`).

## Import Files to TSD
Download the docker images (`mysql.tar.gz`, `phpmyadmin.tar.gz`, `webserver.tar.gz` and `cron.tar.gz` files) from [here](dockerimages) to your local machine.

Also, download the following files (also to your local machine):
* [docker-compose.yml](docker-compose.yml)
* [database.php](webserver/database.php)
* [ldap_config.php](webserver/ldap_config.php)
* [.env](.env)

Also, make sure you have downloaded the REDCap software zip file (e.g. ``redcap11.3.3.zip`` file).

Use https://data.tsd.usit.no to import all the files listed above to your TSD project.

Login to TSD, and connect to the pXX-podman machine (`ssh pXX-podman.tsd.usit.no`). Then execute the following in the terminal:
```bash
export REDCAPDIR=/tsd/pXX/data/durable/database/redcap
mkdir $REDCAPDIR && cd $REDCAPDIR
```

Move all imported files into `$REDCAPDIR`.

Optional: delete all the dangling images and containers (`podman system prune -a`).
Note that this command does not remove volumes (see `podman volume ls` and `podman volume rm <volume>` or `docker-compose down --volumes`, but be extremely careful with these commands as they remove data stored in previous REDCap instances).

## Load and Start Docker Images
Load the docker images
```bash
podman load < webserver.tar.gz
podman load < phpmyadmin.tar.gz
podman load < mysql.tar.gz
podman load < cron.tar.gz
```

Before testing the loaded images, adapt the backup directory in `docker-compose.yml` which defines where the database backups are created (daily backups are scheduled through the [cron](https://en.wikipedia.org/wiki/Cron) container).
```bash
- <<your_backup_directory_path>>:/backup
```
<!-- NB! Note that the above files contain a hard-coded account name and password for the SQL database. Feel free to change it for added security. Then remember to update the commands below (see e.g. [here](#first-time-configuration) ) with your new SQL account name and password. -->

The file [.env](.env) defines variables that are used across containers. Feel free to adapt the prefix which is added to container, volume and network names during the build or the login credentials for the MySQL database:
```bash
PREFIX=
MYSQL_DATABASE=redcap
MYSQL_ROOT_PASSWORD=redcap
MYSQL_REDCAP_USER=redcap_user
```

To make it transparent where this prefix is exactly used throughout this README, we executed `source .env` to make the prefix variable available to the shell. In case you defined an empty string or an easy name (e.g., `redcap_`), feel free to drop `${PREFIX}` in the commands below and replace it with your string accordingly.

Having set the backup path and the MySQL credentials, you can try running
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

## Edit REDCap Configuration Files
Extract the REDCap zip file into `$REDCAPDIR` and:

- update the `database.php` file located [here](webserver/database.php) and place it in the REDCap directory or edit the file manually to adapt the MySQL configuration of REDCap by changing lines 6–19 to:
  ```php
  $hostname   = database;
  $db     = $_ENV['MYSQL_DATABASE'];
  $username   = $_ENV['MYSQL_REDCAP_USER'];
  $password   = $_ENV['MYSQL_ROOT_PASSWORD'];
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

- make the REDCap directory executable and accessible to all users:
  ```bash
  chmod -R 777 ./redcap
  ```

## Copy REDCap into Docker Volume
Copy the REDCap directory into the web server volume via

```bash
podman cp $REDCAPDIR/redcap ${PREFIX}webserver:/var/www/html/
```

The name of the respective container should be `${PREFIX}webserver`. If that is not the case, please adapt the name in the command (all docker containers or volumes can be listed via `podman ps` or `podman volume ls`).

See [here](#docker-volumes) for brief information about docker volumes and how we used them for REDCap deployment.

##  First-time Configuration
Access REDCap from your browser on `pXX-podman.tsd.usit.no:8000/redcap/install.php`, which should display instructions for REDCap deployment.

Step 1 of the instructions can be skipped as it's already executed by MYSQL's [init.sh](mysql/init.sh) script.

Step 2 should also succeed, showing green-colored ``Connection to the MySQL database 'redcap' was successful!`` text. If you have an error it's likely related to the connection to the database, i.e. the problem is likely in `database.php` file. 

Step 3 is optional. Feel free to modify the parameters, or keep them as defaults.

Press `Generate SQL install script`, and copy the prompted SQL commands. From a browser, log in to phpMyAdmin (`pXX-podman.tsd.usit.no:9000`). NB! At this step use the **root** user credentials (root, $MYSQL_ROOT_PASSWORD (see [.env](.env), the default password is "redcap"; do not confuse *root* user with $MYSQL_REDCAP_USER also defined in the [.env](.env) - you should not use $MYSQL_REDCAP_USER in phpMyAdmin for connecting to MySQL database). Once phpMyAdmin is connected to the MySQL database, to the SQL tab, paste the copied SQL commands, and press `Go`. 

Some checks likely fail because of a lack of internet access, while other things can be resolved after login.

If the URL was not altered, a REDCap instance should now be accessible via `pXX-podman.tsd.usit.no:8000/redcap`. The instance can be stopped by terminating the run dockers via

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

Once adding TSD user credentials works, reverse the authentication once more to make yourself or the respective users admins via `Control Center` &rarr; `Administrator Privileges`.

To enable API tokens to be generated by users without the admins' approval, go to `User Settings` &rarr; `General User Settings` and select `Yes, allow ALL users to generate API tokens on their own`.

## Restore SQL database Backups
To restore the REDCap database using the `mysqldump` utility (after a new install; remember that the installed version of the REDCap must precisely match the version used to generate SQL backup!) unzip the backup file via 
```bash
crontab /etc/cron.d/cronjob.sh
```
and run:
```bash
cat SQL_BACKUP_FILE | podman exec -i ${PREFIX}database /usr/bin/mysql -u root --password=${MYSQL_ROOT_PASSWORD} redcap
```

And restart the REDCap database container via
```bash
podman restart ${PREFIX}database
```

## Upgrade REDCap to a Newer Version
Following the steps for the REDCap installation, version-specific entries were added to the MySQL database via phpMyAdmin. Hence, it is not possible to just replace the files in the webserver volume. 

To properly upgrade REDCap, note down the current version of the REDCap instance (it will be needed later). Download an "Upgrade Package" of choice from [here](https://redcap.vanderbilt.edu/community/custom/download.php) (see also the "Upgrade Instructions.txt" in the downloaded zip file). Import the `redcapX.X.X_upgrade.zip` file to `$REDCAPDIR` and unzip the archive. Copy the version-specific directory to the webserver volume via:
```bash
podman cp $REDCAPDIR/redcap/* ${PREFIX}webserver:/var/www/html/redcap/
```

Perform the upgrade via a browser: 
```html
pXX-podman:8000/redcap/redcap_vX.X.X/upgrade.php
```

and follow the displayed steps. If the update was successful, remove the prior REDCap version via
``` bash
podman exec ${PREFIX}webserver rm -rf ./redcap/redcap_vX.X.X
```

## Multiple Instances
It is possible to run multiple instances of REDCap on the same machine, for example, one for production, and one for development. To start the second instance,
copy `docker-compose.yml` and `.env` to a new directory (e.g. ``redcap_dev``). Adapt the backup path in `docker-compose.yml` and adapt the prefix and ports in  the `.env` file:

``` bash
PREFIX=redcap_dev_
PHPMYADMIN_PORT=9009
REDCAP_PORT=8009
```

From that directory, execute `docker-compose up -d` and proceed with the steps [above](#copy-redcap-into-docker-volume).

## Frequently Asked Questions
<!-- If REDCap is not loading through the browser, restart the docker daemon service on pXX-podman
```bash
sudo systemctl restart docker-rootless.service
``` -->

Useful command, connecting to the docker containers (good to know but should not be needed):
```bash
podman exec -it <<container name>> /bin/bash
```

Tracking the output of all containers defined in `docker-compose.yml`
```bash
docker-compose logs --tail=0 --follow
```

For the web server, settings such as upload or memory limit settings can be changed by editing `/usr/local/etc/php/php.ini`. We adapted relevant values already with [phpinit.sh](webserver/phpinit.sh), but they can be further changed on the running container if needed.

If you have trouble using `vim` execute the `“set mouse=”` command within the container as described [here](https://vi.stackexchange.com/questions/18001/why-cant-i-paste-commands-into-vi) and restart the docker web server with `podman restart ${PREFIX}webserver`.

## Local Testing
To try REDCap on your local machine (given the cloned repository and the `.tar.gz` files), follow the steps under [REDCap Deployment](#redcap-deployment), but with differing addresses:
  - phpMyAdmin: http://localhost:9000
  - REDCap: http://localhost:8000/redcap

## Docker Volumes
As defined in [docker-compose.yml](docker-compose.yml) file, we use two volumes for REDCap deployment. 
The first volume, ``redcap_mysql_datavolume``, is responsible for storing SQL database files. The second volume, ``redcap_webserver``, stores REDCap software files, which you upgrade to move to a newer version of REDCap software.
These docker volumes are [persistent](https://docs.docker.com/storage/volumes/), in a sense that after ``docker-compose down`` the volumes are kept, and the same volumes are used after docker containers are re-started with ``docker-compose up`` (They can be removed via `docker-compose down --volumes`).

These volumes should be locally located under

```bash
/var/lib/user/containers/.local/share/docker/volumes/
```

The exact names can be determined via 
```bash
podman volume ls 
```

and their respective mount points via
```bash
podman inspect <<volume_name>>
```

In the case of the MySQL database, it should be (w.r.t. the path above) `./${PREFIX}database/_data`.
