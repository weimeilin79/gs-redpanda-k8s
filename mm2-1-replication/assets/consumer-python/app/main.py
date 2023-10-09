import random, json, time, os
from consumer import *
from flask import Flask
app = Flask(__name__)
app.config.from_pyfile('config/app.properties')
TOPIC = app.config['TOPIC_TO_READ']
BOOTSTRAP_SERVERS = app.config['BOOTSTRAP_SERVERS']
try:
    CONSUMER_GROUP = os.getenv('CONSUMER_GROUP')
except KeyError:
    CONSUMER_GROUP = 'DEFAULT_GROUP'


def main():
    # create a config and producer instance
    print(f"Consumed start -- With group {CONSUMER_GROUP}")
    config = ConsumerConfig(topics=TOPIC, bootstrap_servers=BOOTSTRAP_SERVERS, consumer_group=CONSUMER_GROUP )
    rp = Consumer(config)
    
    logging.info('Processing record from Redpanda...')    
    for msg in rp.client:
       print(f"Consumed record. key={msg.key}, value={msg.value}")
            

if __name__ == '__main__':
    main()