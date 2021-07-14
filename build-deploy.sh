#!/bin/bash

echo "Setting CAMUNDA env variables"
export CAMUNDA_USER=camunda
export CAMUNDA_PASSWORD=camunda
export CAMUNDA_DB=process-engine
export CAMUNDA_DATA=$PWD/docker/volumes/postgres


echo "creating volume directory for postgres db"
mkdir -p $PWD/docker/volumes/postgres
chmod 777 -R $PWD/docker

echo "Building Images.... [DB,APP]"
docker build --target DB -t camunda/db --build-arg  DBUSER=$CAMUNDA_USER  --build-arg  \
DBPWD=$CAMUNDA_PASSWORD  --build-arg  DBNAME=$CAMUNDA_DB .

docker build --target APP -t camunda/app --build-arg  DBUSER=$CAMUNDA_USER  --build-arg \
DBPWD=$CAMUNDA_PASSWORD  --build-arg  DBNAME=$CAMUNDA_DB  . 

# create custom camunda DB bridge network
docker network create camunda-db-bridge 


echo "DB Container ... Starting [DB]"
# db
docker run --rm  --name db --net camunda-db-bridge \
-d -p 5432:5432 \
-v $CAMUNDA_DATA:/var/lib/postgresql/data \
camunda/db

echo "APP Container...Starting [APP]"
# app
docker run -d --name camunda --net camunda-db-bridge -p 8081:8080 \
camunda/app

echo "DONE"
