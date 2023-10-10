
### Migrating consumers
We will now transfer all the consumer groups from the source cluster to the destination Redpanda cluster. The most challenging aspect of this migration is ensuring that there's no duplication in message processing.


Stop consumer in group A which are drawing from the source cluster:
```
docker stop  $(docker ps | grep mm2consumer-A | awk '{ print $1 }')
docker rm mm2consumer-A
```{{exec}}

Restart the consumer in the Group A and start consume from the new Redpanda cluster:
```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='A_GROUP' \
--name mm2consumer-A \
weimeilin/mm2consumer 
```{{exec}}



Stop all the consumers of consumer group B which are drawing from the source cluster:
```
docker stop  $(docker ps | grep mm2consumer-B1 | awk '{ print $1 }')
docker stop  $(docker ps | grep mm2consumer-B2 | awk '{ print $1 }')

docker rm mm2consumer-B1
docker rm mm2consumer-B2
```{{exec}}

Restart the consumers group B and start consume from the new Redpanda cluster:
```
docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
--name mm2consumer-B1 \
weimeilin/mm2consumer 

docker run -d --network=root_redpanda_network \
-e BOOTSTRAP_SERVERS='redpanda-0:9092' \
-e CONSUMER_GROUP='B_GROUP' \
--name mm2consumer-B2 \
weimeilin/mm2consumer 
```{{exec}}


### Migrating producer
We're now shifting the producers from the source to the destination Redpanda cluster. In our setup, message order within the topic wasn't a concern. Given that data replication was ongoing, a simple restart of the producer will do the trick.

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


### Shut down Kafka and zookeeper

Now nothing is connected to the old cluster, we can go ahead and shut it down. 
```
docker stop  $(docker ps | grep root_kafka_1 | awk '{ print $1 }')
docker stop  $(docker ps | grep root_zookeeper_1 | awk '{ print $1 }')
docker rm root_kafka_1
docker rm root_zookeeper_1
```{{exec}}

Check only the new cluster and clients running: 
```
docker ps --format '{{.Names}}'
```{{exec}}

You should see only the following services:
```
```

Check if all clients are still getting streamed data
```
docker logs -t mm2consumer-A
```{{exec}}

```
docker logs -t mm2consumer-B1
```{{exec}}


Congratulation, you have completed migrating from Kafka to Redpanda cluster.


Have fun! 