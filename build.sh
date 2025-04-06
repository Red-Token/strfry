#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Error. You must use sudo"
    exit 1
fi

if ! command -v docker &>/dev/null; then
    echo "Error. Docker is not installed"

    read -p "Do you want to install Docker? (y/n): " answer
    answer=${answer:-n}
    case "$answer" in
    y | Y)
        echo "Continue run script..."
        bash <(curl -sSL https://get.docker.com)
        ;;
    N | N)
        echo "Exit."
        exit 0
        ;;
    *)
        echo "Incorrect input. Exit from the script."
        exit 1
        ;;
    esac

fi

PACKAGE_NAME=strfry-nostr-relay

if [ "$1" == "prod" ]; then
    DOCKER_NAME=${DOCKERHUB_USERNAME}/$PACKAGE_NAME
else
    DOCKER_NAME=$PACKAGE_NAME
fi

export VERSION=1.0.4

export DOCKER_NAME=$DOCKER_NAME

echo "Starting build for version: ${VERSION}..."

docker stop nostr-relay
docker stop community-relay

docker compose -f docker-compose-build.yaml down
docker system prune -a -f

docker compose -f docker-compose-build.yaml build --no-cache
docker compose -f docker-compose-build.yaml up -d
