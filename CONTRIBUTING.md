# Contributing

Thanks for considering contributing! Please read this document to learn the various ways you can contribute to this project and how to go about doing it.

## Bug reports and feature requests

You're welcome to [submit bug reports and feature fequests](https://github.com/norment/redcap/issues) 

## Pull requests

You're also welcome to submit a pull request suggesting changes.
Remember to update [CHANGELOG.md](CHANGELOG.md) to describe the changes.

# Creating Docker Images

The following steps enable the production of the relevant files for a Docker-based REDCap deployment.

## Prerequisites
Have [Docker](https://www.docker.com/) locally installed on a machine (Ubuntu or any other Linux distribution; see also [here](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04)). Ideally, containers should be built on our dedicated [NREC](https://dashboard.nrec.no/dashboard/auth/login/?next=/dashboard/) instance, to avoid accidental changes due to version of the Docker used to re-build containers. Please see [here](https://wiki.norment.uiocloud.no/doku.php?id=how_to_apply_for_nortur_norstor_account) on how to get access to our NREC instance.
  
## Make .tar.gz files
On a terminal
```bash
git clone git@github.com:norment/redcap.git
# or if that does not work
git clone https://"ghp_your_git_token"@github.com/norment/redcap.git
```
`cd` into the directory and execute `make`. This step will produce three `.tar.gz` files containing the relevant docker images (webserver, MySQL, and phpMyAdmin; see [here](https://github.com/norment/redcap/blob/main/Makefile))

Optionally run `docker-compose up` to test that all services can start.

Import the `tar.gz` files to the respective pXX (store them under `$REDCAPDIR`), and upload them to this git repository (`dockerimages/`).

## Legacy information

We also have deprecated instructions to install REDCap [here](https://docs.google.com/document/d/1ENwkYVIONqyvbD22SQG9SQkmu05OXZmm/edit?dls=true).


