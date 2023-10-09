
1/ Migrate consumer
Stop the consumer A
```
docker stop  $(docker ps | grep mm2consumer-A | awk '{ print $1 }')
```{exec}

```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='A_GROUP' \
-h mm2consumer-A
mm2consumer 
```{{exec}}

Migrate consumer B1
```
docker stop  $(docker ps | grep mm2consumer-B1 | awk '{ print $1 }')

docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
-h mm2consumer-B1
mm2consumer 
```{{exec}}

Migrate consumer B2
```
docker stop  $(docker ps | grep mm2consumer-B2 | awk '{ print $1 }')

docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
-h mm2consumer-B1
mm2consumer 
```{{exec}}

2/ Migrate producer 

```
docker stop  $(docker ps | grep mm2producer | awk '{ print $1 }')
```{exec}

```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-h mm2producer
mm2producer
```{{exec}}

3/ Shut down Kafka and zookeeper

Click [Redpanda Console]({{TRAFFIC_HOST1_8080}}/) to access it in your browser.

Have fun! 