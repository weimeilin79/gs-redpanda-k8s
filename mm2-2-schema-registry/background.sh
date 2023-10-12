#!/bin/bash

sudo apt update
sudo apt install -y default-jdk
sudo apt install -y maven 

docker-compose -f docker-compose-rp.yaml pull
