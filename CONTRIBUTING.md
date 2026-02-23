# Contributing

Thanks for considering contributing! Please read this document to learn the various ways you can contribute to this project and how to go about doing it.

## Bug reports and feature requests

You're welcome to [submit bug reports and feature requests](https://github.com/norment/redcap/issues) 

## Pull requests

You're also welcome to submit a pull request suggesting changes.
Remember to update [CHANGELOG.md](CHANGELOG.md) to describe the changes.

# Creating and Publishing Docker Images

The following steps publish the container images to GHCR. Maintainers should use `docker` for building and pushing images.

## Prerequisites
Have [Docker](https://www.docker.com/) installed on a machine (Ubuntu or any other Linux distribution). Ideally, containers should be built on our dedicated [NREC](https://dashboard.nrec.no/dashboard/auth/login/?next=/dashboard/) instance, to avoid accidental changes due to version differences in the container runtime. Please see [here](https://wiki.norment.uiocloud.no/doku.php?id=how_to_apply_for_nortur_norstor_account) on how to get access to our NREC instance.
  
## Publish images to GHCR
Use `docker` for building and pushing.

Pick a tag and authenticate to GHCR:
```bash
export IMAGE_TAG=latest  # set this to a versioned tag for releases
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <github-username> --password-stdin
```

Build and tag the images:
```bash
docker build -t ghcr.io/norment/redcap-webserver:${IMAGE_TAG} webserver
docker build -t ghcr.io/norment/redcap-phpmyadmin:${IMAGE_TAG} phpmyadmin
docker build -t ghcr.io/norment/redcap-mysql:${IMAGE_TAG} mysql
docker build -t ghcr.io/norment/redcap-cron:${IMAGE_TAG} cron
```

Push the images:
```bash
docker push ghcr.io/norment/redcap-webserver:${IMAGE_TAG}
docker push ghcr.io/norment/redcap-phpmyadmin:${IMAGE_TAG}
docker push ghcr.io/norment/redcap-mysql:${IMAGE_TAG}
docker push ghcr.io/norment/redcap-cron:${IMAGE_TAG}
```

If you publish a new tag, update `IMAGE_TAG` in `.env` to match.

Note: `podman load` on TSD preserves the image name/tag stored in the tar. Ensure the offline bundle is created from the GHCR-tagged images (e.g., `ghcr.io/norment/redcap-webserver:${IMAGE_TAG}`), otherwise TSD users will need to retag after loading.

## Legacy information

We also have deprecated instructions to install REDCap [here](https://docs.google.com/document/d/1ENwkYVIONqyvbD22SQG9SQkmu05OXZmm/edit?dls=true).
