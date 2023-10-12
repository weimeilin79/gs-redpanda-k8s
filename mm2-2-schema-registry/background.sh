#!/bin/bash


sudo apt install -y default-jdk
sudo apt install -y maven 

docker-compose -f docker-compose-rp.yaml pull

cd /root/quarkus-apps/avro-schema-producer
./mvnw install

cd /root/quarkus-apps/avro-schema-consumer
./mvnw install