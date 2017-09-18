import paho.mqtt.client as mqtt
def publisher():
    client.publish("/test/topic2", "Hello, World!")
    client.loop(3) 
 
