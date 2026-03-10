#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/build_images.sh [--push] [--tag <tag>] [--platform <linux/amd64|linux/arm64>]

Defaults:
  --tag:      $IMAGE_TAG or "latest"
  --platform: host architecture (only used without --push)

Notes:
  - Without --push, builds a single-platform image and loads it into the local Docker engine.
  - With --push, builds a multi-arch manifest for linux/amd64 and linux/arm64 and pushes to GHCR.
  - phpMyAdmin is mirrored from the upstream phpmyadmin:5.2-apache image.
USAGE
}

IMAGE_TAG="${IMAGE_TAG:-latest}"
PUSH=0
PLATFORM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --push)
      PUSH=1
      shift
      ;;
    --tag)
      IMAGE_TAG="${2:-}"
      shift 2
      ;;
    --platform)
      PLATFORM="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "${IMAGE_TAG}" ]]; then
  echo "IMAGE_TAG must be set (or use --tag)." >&2
  exit 1
fi

if [[ "${PUSH}" -eq 0 ]]; then
  if [[ -z "${PLATFORM}" ]]; then
    case "$(uname -m)" in
      x86_64|amd64) PLATFORM="linux/amd64" ;;
      arm64|aarch64) PLATFORM="linux/arm64" ;;
      *)
        echo "Unknown host architecture; set --platform explicitly." >&2
        exit 1
        ;;
    esac
  fi
else
  PLATFORM="linux/amd64,linux/arm64"
fi

docker buildx create --use --name redcap-multiarch >/dev/null 2>&1 || docker buildx use redcap-multiarch
docker buildx inspect --bootstrap >/dev/null

build_one() {
  local name="$1"
  local context="$2"
  local image="ghcr.io/norment/redcap-${name}:${IMAGE_TAG}"

  if [[ "${PUSH}" -eq 1 ]]; then
    docker buildx build --platform "${PLATFORM}" -t "${image}" --push "${context}"
  else
    docker buildx build --platform "${PLATFORM}" -t "${image}" --load "${context}"
  fi
}

mirror_one() {
  local name="$1"
  local source_image="$2"
  local target_image="ghcr.io/norment/redcap-${name}:${IMAGE_TAG}"

  if [[ "${PUSH}" -eq 1 ]]; then
    docker buildx imagetools create --tag "${target_image}" "${source_image}"
  else
    docker pull --platform "${PLATFORM}" "${source_image}"
    docker tag "${source_image}" "${target_image}"
  fi
}

build_one webserver webserver
mirror_one phpmyadmin phpmyadmin:5.2-apache
build_one mysql mysql
build_one cron cron
