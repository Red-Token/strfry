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

echo "Starting build..."

docker compose down
docker system prune -a -f

docker compose -f docker-compose-build.yaml build --no-cache
docker compose up -d
