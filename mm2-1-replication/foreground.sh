#! /bin/bash

# build and pull the images while the user is reading the intro
cd /root
docker-compose -f docker-compose-clients.yaml pull
docker-compose -f docker-compose-rp.yaml pull
docker-compose -f docker-compose-kafka.yaml pull

docker-compose -f docker-compose-kafka.yaml up -d



