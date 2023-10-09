
1/ Check if the Kafka instance is up, by running the producer and consumer 

a. Create a new *Topic*
```
docker exec -it assets_kafka_1 kafka-topics --create --topic foo --partitions 2 --replication-factor 1 --if-not-exists --bootstrap-server localhost:9094
```
b. Test by Send data into producer
```
docker exec -it assets-kafka-1 kafka-console-producer --broker-list localhost:29094 --topic foo 
```
c. Test by Receive data from consumer
```
docker exec -it assets-kafka-1 kafka-console-consumer --bootstrap-server localhost:9094 --topic foo 
```

3/ Start the running clients

```
docker compose -f docker-compose-clients.yaml up -d
```


Overview
Kafka single node cluster 
Load the topics and data into Kafka cluster
Start the Redpanda cluster 
Setup and view MM2 
Fan out 


Click [Redpanda Console]({{TRAFFIC_HOST1_8080}}/) to access it in your browser.

Have fun! 