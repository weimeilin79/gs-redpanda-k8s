
1/ Migrate consumer
Stop the consumer A
```
docker stop  $(docker ps | grep mm2consumer-A | awk '{ print $1 }')
docker rm mm2consumer-A
```{{exec}}

```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='A_GROUP' \
--name mm2consumer-A \
weimeilin/mm2consumer 
```{{exec}}

TESTING
```
docker run -d --network=assets_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='A_GROUP' \
--name mm2consumer-A \
weimeilin/mm2consumer 
```

```
docker logs -t mm2consumer-A
```{{exec}}


Migrate consumer B1
```
docker stop  $(docker ps | grep mm2consumer-B1 | awk '{ print $1 }')
docker rm mm2consumer-B1

docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
--name mm2consumer-B1 \
weimeilin/mm2consumer 
```{{exec}}

```
docker logs -t mm2consumer-B1
```{{exec}}

Migrate consumer B2
```
docker stop  $(docker ps | grep mm2consumer-B2 | awk '{ print $1 }')
docker rm mm2consumer-B2

docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
--name mm2consumer-B2 \
weimeilin/mm2consumer 
```{{exec}}

```
docker logs -t mm2consumer-B2
```{{exec}}

2/ Migrate producer 

```
docker stop  $(docker ps | grep mm2producer | awk '{ print $1 }')
docker rm mm2producer
```{{exec}}

```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
--name mm2producer \
weimeilin/mm2producer
```{{exec}}

TESTING
```
docker run -d --network=assets_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
--name mm2producer \
weimeilin/mm2producer
```

TESTING
```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='kafka:9094' \
--name mm2producer \
weimeilin/mm2producer
```

```
docker logs -t mm2producer
```{{exec}}

3/ Shut down Kafka and zookeeper
```
docker stop  $(docker ps | grep root_kafka_1 | awk '{ print $1 }')
docker stop  $(docker ps | grep root_zookeeper_1 | awk '{ print $1 }')
docker rm root_kafka_1
docker rm root_zookeeper_1
```{{exec}}

```
docker logs -t mm2consumer-A
```{{exec}}

```
docker logs -t mm2consumer-B1
```{{exec}}

```
docker logs -t mm2consumer-B2
```{{exec}}



Click [Redpanda Console]({{TRAFFIC_HOST1_8080}}/) to access it in your browser.

Have fun! 