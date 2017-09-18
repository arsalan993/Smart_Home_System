import subprocess
import time
import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
#from pub import *

from new import *


import socket

ind = 0
temp_str = []
def Mosquitto_Start():
    proc = subprocess.Popen(["mosquitto"], stdout=subprocess.PIPE, shell=True)
def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]  

#Mosquitto_Start()
fo = open("/home/odroid/Desktop/FinalPython/topics.txt", "r")
data_topic = fo.readlines()
fo.close()
f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
data_UP = f1.readlines()
user = data_UP[0].strip()

passw = data_UP[1].strip()

print user
print passw
f1.close()
def online1():
    
    # The callback for when the client receives a CONNACK response from the server.
    def on_connect(client, userdata, rc):
        print("Connected with result code "+str(rc))
        print(data_topic)
        print(userdata)
        for u in data_topic:
            mac = u[0:18].strip()
            u = u[18:len(u)-1]
            print("/" + mac + u)
            print(len(u))
            client.subscribe("/" + mac + u)
    


    # The callback for when a PUBLISH message is received from the server.
    def on_message(client, userdata, msg):
        print("Topic: ", msg.topic+'\nMessage: '+str(msg.payload))
        if msg.payload != "":
            publish.single(msg.topic,msg.payload, hostname=get_ip_address(),port=1883, client_id="qwertdfytk",auth={'username':user,'password':passw},qos=1, retain=False)
            #publish.single(msg.topic,"", hostname="videoupload.hopto.org",port=1234 ,client_id="qwergfdftk",auth={'username':user,'password':passw},qos=1, retain=False)
       
        
        
     

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

