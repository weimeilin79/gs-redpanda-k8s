
1/ Verify that the Kafka instance is active by initiating both the producer and consumer.

Firstly, create a new Topic:
```
docker exec -it root_kafka_1 kafka-topics --create --topic woo --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server localhost:29094
```{{exec}}

*Next*, open a new tab (tab 2) and launch a producer:
```
docker exec -it root_kafka_1 kafka-console-producer --broker-list localhost:29094 --topic woo 
```{{exec}}

In another new tab (tab 3), start a consumer:
```
docker exec -it root_kafka_1 kafka-console-consumer --bootstrap-server localhost:29094 --topic woo 
```{{exec}}

Now, return to tab 2, and try typing to send data to the *woo* topic using the producer. Switch to tab 3 and verify if the consumer receives the data. 

To conclude this step, terminate the consumer in tab 3 by pressing `Ctrl+C`.


2/ Initialize the clients

We will activate several consumers and a producer to emulate data streaming into the existing Kafka platform. The setup will include a producer that inputs data randomly into a topic named *foo*, along with 3 consumers: one consumer in group_A and two consumers in group_B. 

Begin by creating a new *Topic*:

```
docker exec -it root_kafka_1 kafka-topics --create --topic foo --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server localhost:29094
```{{exec}}

Start the clients:
```
docker-compose -f docker-compose-clients.yaml up -d
```{{exec}}

