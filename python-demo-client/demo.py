import sys
import time
from threading import Thread
from datetime import datetime

import paho.mqtt.client as mqtt

def send_worker(client):
    time.sleep(1)
    while True:
        client.publish('demo/current-timestamp', str(datetime.now()))
        time.sleep(3)

def on_connect(client, userdata, flags, rc):
    print("Successfully connected to MQTT Server", file=sys.stderr)
    client.subscribe("#")

def on_message(client, userdata, msg):
    print(f"got message on topic: {msg.topic} : {msg.payload}", file=sys.stderr)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.tls_set(certfile="./cert.pem", keyfile="./key.pem", ca_certs="./ca.pem")
client.connect("mqtt-broker", port=8883)

worker = Thread(target=send_worker, args=(client, ), daemon=True)
worker.start()

client.loop_forever()
