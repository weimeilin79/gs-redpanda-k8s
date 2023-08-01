**Consumers** read data from one or more Redpanda topics. As long as the source topics have more than one partition, they can even work together in groups (called **Consumer groups**) to split the read workload. The max parallelism is determined by the number of partitions in a topic.

Pub/sub systems like Redpanda and Kafka are often confused with queuing systems. However, one major difference is that queues have destructive consumer semantics. In other words, a message is read once and then popped off the queue.

With Redpanda, messages can be read by multiple consumers groups, and will continue to be available until the message is eventually purged according to the topic's cleanup policy.
