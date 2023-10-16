#!/bin/bash

docker pull weimeilin/mm2consumer:latest
docker pull weimeilin/mm2producer:latest
docker-compose -f docker-compose-rp.yaml pull


sudo apt install -y jq
