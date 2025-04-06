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
        echo "Installing Docker..."
        bash <(curl -sSL https://get.docker.com)
        ;;
    n | N)
        echo "Exit."
        exit 0
        ;;
    *)
        echo "Incorrect input. Exit from the script."
        exit 1
        ;;
    esac
fi

echo "Starting nostr-relay deployment..."

docker stop nostr-relay
docker stop community-relay

docker compose -f docker-compose-strfry.yaml down
docker system prune -a -f

docker compose -f docker-compose-strfry.yaml up -d --force-recreate
# docker compose up --pull always -d
