# Changelog

All notable changes to this project will be documented in this file.
This is also an operational log of our REDcap deployment and management.

* changes to deployment procedures (e.g. changes in Docker files, backup scripts, etc.)
* changes to the deployment itself (e.g. building new docker images, with a path to where we store them, deployment of REDcap to new TSD projects, updating existing deployments to newer versions, restoring form backups, etc.) 
* changes to infrastructure (e.g. switching to a new service VM, changing what service user we run the service from, etc.)
* important changes to scripts that manage data within REDcap

## 2026-03-06

- Introduce explicit GHCR image versioning for the REDCap stack.
- Reserve `1.0.0` for the previously published `latest` images (equivalent to the former LFS bundle content).
- Reserve `2.0.0` for images rebuilt from the current multi-arch codebase (`linux/amd64` and `linux/arm64`).
- Keep `latest` for convenience while using semantic version tags for reproducible deployments.

## 2026-02-25

- Make the webserver LDAP build multi-arch by resolving the libdir dynamically
- Switch phpMyAdmin to the upstream `phpmyadmin:5.2-apache` image and drop the custom Dockerfile/build steps
- Update compose and installation/contribution instructions to match the new phpMyAdmin source and multi-arch builds
- Add a build helper script to separate local builds from multi-arch pushes

## 2026-02-24

- Upgrade container bases for REDCap 16: PHP 8.4 (min PHP >= 8.1), MySQL 8.4 LTS (8.0 nearing EOL), phpMyAdmin 5.2 series, and Ubuntu 24.04 LTS for cron
- Move MySQL tuning to `/etc/mysql/conf.d/` to match MySQL 8.4 image layout and keep config explicit
- Replace tracked `webserver/database.php` with a script to patch `redcap/database.php` to read DB credentials and salt from `$_ENV`
- Add `scripts/README.md` and implement the LDAP helper `configure_ldap_config_usit_tsd.sh`

## 2026-02-23

- Switch container image distribution to GHCR with offline bundle workflow; remove prebuilt LFS image artifacts
- Improve instructions for local testing

## 2023-11-23

- Support multiple REDcap instances on a single machine

## 2023-11-21
- Added containerized cronjob
- Added .env where variables are defined

## 2023-09-21
- Elaborating the README on both REDcap deployment and creation
- Importing the cron job backup script from TSD p33
- Adding of the docker images (.tar.gz)

## 2023-05-03

- Modified Dockerfiles to enhance the performance 

## 2023-04-11

- This change log was created
