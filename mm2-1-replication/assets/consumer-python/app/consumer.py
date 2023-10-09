"""
Create a Redpanda Consumer
"""

import os, json, signal, logging
from dataclasses import dataclass
from kafka import KafkaConsumer

@dataclass
class ConsumerConfig:
    def __init__(
        self, topics: str,
        bootstrap_servers,
        consumer_group,
        auto_offset_reset='latest',
        value_deserializer = lambda m: json.loads(m.decode('ascii'))
    ) -> None:
        self.bootstrap_servers = bootstrap_servers
        self.topics = topics
        self.consumer_group = consumer_group
        self.auto_offset_reset = auto_offset_reset
        if value_deserializer:
            self.value_deserializer = value_deserializer

class Consumer:
    def __init__(self, config: ConsumerConfig) -> None:
        signal.signal(signal.SIGINT, self.sigterm_handler)
        signal.signal(signal.SIGTERM, self.sigterm_handler)

        self.client = KafkaConsumer(
            config.topics,
            group_id=config.consumer_group,
            auto_offset_reset=config.auto_offset_reset,
            value_deserializer = config.value_deserializer,
            bootstrap_servers = config.bootstrap_servers
        )
        self.topics = config.topics
            
            

    def sigterm_handler(self, signum, frame):
        logging.info("Closing consumer.")
        self.client.close(autocommit=False)
        raise SystemExit
