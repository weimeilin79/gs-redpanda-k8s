

docker exec -it root_kafka_1 kafka-topics --create --topic foo --partitions 1 --replication-factor 1 --if-not-exists --bootstrap-server localhost:9094

docker exec -it root_kafka_1 kafka-console-producer --broker-list localhost:29094 --topic foo 

docker exec -it root_kafka_1 kafka-console-consumer --bootstrap-server localhost:9094 --topic foo -from-beginning --max-messages 42

docker run --net=host --rm confluentinc/cp-kafka:latest bash -c "seq 42 | kafka-console-producer --broker-list localhost:29094 --topic foo && echo 'Produced 42 messages.'"



Click [Redpanda Console]({{TRAFFIC_HOST1_80}}/) to access it in your browser.

Have fun! 