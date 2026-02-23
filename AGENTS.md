**Repo Spec**
- This repository supports REDCap deployment both locally and on TSD.
- Local deployment uses `docker`.
- TSD deployment uses `podman`.
- Both local and TSD workflows are intended for users of this repository.

**Maintainer Spec**
- Maintainers rebuild container images and publish them to GHCR.
- Maintainers must use `docker` (not `podman`) for building and pushing images.
