#!/bin/bash

export PATH="~/.local/bin:$PATH"
#export REDPANDA_BROKERS="172.30.1.2:31092"

export random_value=$(echo $RANDOM | base64 | head -c 20; echo) 
export random_sleeptime=$(shuf -i1-5 -n1)
while :
do
   echo $random_value | rpk topic produce demo-topic --allow-auto-topic-creation --brokers localhost:31092 >/dev/null 
   sleep $random_sleeptime >/dev/null 
done
