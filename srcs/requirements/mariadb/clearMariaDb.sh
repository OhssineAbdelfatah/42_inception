#!/bin/bash

set -e

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker volume rm $(docker volume ls -q)
docker rmi $(docker image ls -qa)
