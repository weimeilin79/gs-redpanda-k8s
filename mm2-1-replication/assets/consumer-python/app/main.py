import random, json, time, os
from consumer import *
from flask import Flask
app = Flask(__name__)
app.config.from_pyfile('config/app.properties')
TOPIC =  os.getenv('TOPIC_TO_READ') or app.config['TOPIC_TO_READ']
BOOTSTRAP_SERVERS = os.getenv('BOOTSTRAP_SERVERS') or app.config['BOOTSTRAP_SERVERS']
try:
    CONSUMER_GROUP = os.getenv('CONSUMER_GROUP') or 'DEFAULT_GROUP'
except KeyError:
    CONSUMER_GROUP = 'DEFAULT_GROUP'


def main():
    # create a config and producer instance
    print(f"Consumed start -- With group {CONSUMER_GROUP} and BOOTSTRAP_SERVERS {BOOTSTRAP_SERVERS}")
    config = ConsumerConfig(topics=TOPIC, bootstrap_servers=BOOTSTRAP_SERVERS, consumer_group=CONSUMER_GROUP )
    rp = Consumer(config)
    
    logging.info('Processing record from Redpanda...')    
    for msg in rp.client:
       print(f"Consumed record. offset={msg.offset} key={msg.key}, value={msg.value}")
            

if __name__ == '__main__':
    main()