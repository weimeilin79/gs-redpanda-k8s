#!/bin/bash

# Set up java
sudo apt install -y default-jdk
sudo apt install -y maven 
sudo apt install -y jq

# pull RP images in the background
docker-compose -f docker-compose-rp.yaml pull

# pulling jars ahead of time, in the background
cd /root/quarkus-apps/avro-schema-producer
./mvnw install

cd /root/quarkus-apps/avro-schema-consumer
./mvnw install


# Setup Python 3.11 needed by the schema migration tool
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install -y python3.11
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 

# Setup rpk
curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip
mkdir -p ~/.local/bin
unzip rpk-linux-amd64.zip -d ~/.local/bin/
export PATH="~/.local/bin:$PATH"