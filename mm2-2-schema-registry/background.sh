#!/bin/bash

# Set up java
sudo apt install -y default-jdk
sudo apt install -y maven 
apt  install -y jq

# pull RP images in the background
docker-compose -f docker-compose-rp.yaml pull

# pulling jars ahead of time, in the background
cd /root/quarkus-apps/avro-schema-producer
./mvnw install

cd /root/quarkus-apps/avro-schema-consumer
./mvnw install



sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt install  -y python3.11