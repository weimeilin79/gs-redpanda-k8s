#!/bin/bash

# build and pull the images while the user is reading the intro
apt-get install -y jq
docker pull docker.redpanda.com/redpandadata/redpanda:v23.1.8
docker pull flink:1.16.0-scala_2.12-java11