#!/bin/bash

# build and pull the images while the user is reading the intro
cd /root
docker-compose pull
docker-compose build