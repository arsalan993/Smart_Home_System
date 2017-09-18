import subprocess
import time
import socket
from reconnect import *
import platform, os, logging
#while True:
 #   subprocess.call("/home/odroid/Desktop/FinalPython/test_refresh.sh")
  #  time.sleep(10)
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0] 

while 1:
    if len(all_interfaces()) > 1:
        matching = [s for s in all_interfaces() if get_ip_address() in s]
        if matching == []:
            print ("not found")            
        else:
            print ("network is up")
            break
                       
    else:
        print ("network down")
    time.sleep(2)
time.sleep(2)


f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
data_UP = f1.readlines()
user = data_UP[0].strip()
passw = data_UP[1].strip()

print user
print passw
f1.close()

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, rc):
    print("Connected with result code "+str(rc))
    
    client.subscribe("/stream/refresh")
    print(userdata)
    

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print("Topic: ", msg.topic+'\nMessage: '+str(msg.payload))
    
    if msg.topic=="/stream/refresh":
        subprocess.call("/home/odroid/Desktop/FinalPython/test_refresh.sh")
    
    
 

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.username_pw_set(user,passw)
#client.connect("mqtt.quadsource.net", 8888, 60)
client.connect("videoupload.hopto.org",1234, 60)
# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
