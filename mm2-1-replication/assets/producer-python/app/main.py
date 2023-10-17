import random, json, time, os
from producer import *
from flask import Flask
app = Flask(__name__)
app.config.from_pyfile('config/app.properties')
TOPIC = app.config['TOPIC_TO_SEND']
BOOTSTRAP_SERVERS = os.getenv('BOOTSTRAP_SERVERS') or app.config['BOOTSTRAP_SERVERS']
SLEEP_TIME = os.getenv('SLEEP_TIME') or app.config['SLEEP_TIME']
MAX_REC = os.getenv('MAX_REC') or app.config['MAX_REC']
MIN_REC = os.getenv('MIN_REC') or 1

def main():
    # create a config and producer instance
    config = ProducerConfig(topic=TOPIC, bootstrap_servers=BOOTSTRAP_SERVERS)
    rp = Producer(config)
    print('Producer starts---')
    # map topics to processors
    
    while (True):
        time.sleep(int(SLEEP_TIME))
        if keepRunning():
            no_msg_sent=random.randint(int(MIN_REC), int(MAX_REC));
            print('Sending '+str(no_msg_sent)+' of message this time! ')
            for _ in range(no_msg_sent):
                bot_data = {    'plantId': random.randint(0, 100),    'botId':'B'+ str(random.randint(0, 100)),    'fulfillment': random.randint(2, 6)    }
                print(bot_data)
                rp.produce(key=str(bot_data['plantId']), message=bot_data)
            

def keepRunning():
    app.config.from_pyfile('config/app.properties')
    SWITCH=app.config['SWITCH']
    if(SWITCH=='ON'):
     return True
    
    return False

if __name__ == '__main__':
    main()