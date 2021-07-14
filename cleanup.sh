#!/bin/bash

docker stop camunda
docker rm camunda
docker stop db
docker rm db

docker network  ls
docker network rm camunda-db-bridge

docker image rm camunda/app
docker image rm camunda/db

# uncomment if need to remove persist data
#rm -r $PWD/docker
