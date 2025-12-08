#!/bin/zsh

set -e
docker build -t mariadb .
docker run  --detach mariadb -t mariadb-container

