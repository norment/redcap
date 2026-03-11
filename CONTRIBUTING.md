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
echo "$GHCR_LOGIN" | docker login ghcr.io -u $GHCR_USERNAME --password-stdin
```

Build images (host platform by default):
```bash
bash scripts/build_images.sh
```

Push multi-arch images to GHCR:
```bash
bash scripts/build_images.sh --push
```

If you publish a new tag, update `IMAGE_TAG` in `.env` to match.

phpMyAdmin uses the upstream `phpmyadmin:5.2-apache` image directly and is not published to GHCR. It is included in the offline bundle pulled from Docker Hub — see [INSTALL.md](INSTALL.md).

Note: `podman load` on TSD preserves the image name/tag stored in the tar. Ensure the offline bundle is created from the GHCR-tagged images (e.g., `ghcr.io/norment/redcap-webserver:${IMAGE_TAG}`), otherwise TSD users will need to retag after loading.
