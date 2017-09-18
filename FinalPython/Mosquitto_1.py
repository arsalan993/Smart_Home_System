import paho.mqtt.client as mqtt
import paho.mqtt.publish as publish
import socket
import subprocess
import time
from new import *
from scan import *
import wifi

ind = 0
temp_str = []
str_ssid = ""
str_pass = ""
from Wireless import Wireless



def Mosquitto_Start():
    proc = subprocess.Popen(["mosquitto"], stdout=subprocess.PIPE, shell=True)


#Mosquitto_Start()
fo = open("/home/odroid/Desktop/FinalPython/topics.txt", "r")
data_topic = fo.readlines()
fo.close()

f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
data_UP = f1.readlines()
user = data_UP[0]
passw = data_UP[1].strip()
user = user[0:len(user)].strip()
f1.close()
print( user[0:len(user)].strip(),passw.strip())

f2 = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
data_mac = f2.readlines()
del data_mac[0:2]
f2.close()
def cmd(cmd):
    return subprocess.Popen(
        cmd, shell=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT
    ).stdout.read().decode()

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]

def offline1():
    
    # The callback for when the client receives a CONNACK response from the server.
    def on_connect(client, userdata, rc):
        print("Connected with result code "+str(rc))
        client.subscribe("/username/password")
        client.subscribe("/config/")
        client.subscribe("/wifi/scan")
        client.subscribe("/wifi/scan/result")
        client.subscribe("/wifi/current")
        client.subscribe("/wifi/ssid")
        client.subscribe("/wifi/password")
        client.subscribe("/wifi/nopassword")
        client.subscribe("/lwt")
        for u in data_topic:
            mac = u[0:18].strip()
            u = u[18:len(u)-1]
            print("/" + mac + u)
            print(len(u))
            client.subscribe("/" + mac + u)
            print "printing status"
            u2 ="/" + mac + u + "/status"
            client.subscribe(u2)
        #if len(data_mac) > 0:
         #   for v in data_mac:
          #      v = v[-18:].strip()
           #     print v
            #    client.subscribe("/lwt/" + v)
            
            
    def on_disconnect(client, userdata, rc):
        
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
        while 1:
            try:
                offline1()
                break
            except:
                print ("offline server not availabe")
                time.sleep(1)
        print ("Exiting offline" )
    # The callback for when a PUBLISH message is received from the server.
    def on_message(client, userdata, msg):
        print ("Topic: ", msg.topic+'\nMessage: '+str(msg.payload))
        print("i have recieved")
        if msg.topic == "/config/":
            x=msg.payload
    ###################### bug ########################
            data_len = len(x)
            FileWriting(x)
            time.sleep(1)
            temp_str = []
            print ("entering data acquisition funtion") 
            Data_Acquisition()
            #client.reinitialise(client_id="", clean_session=True, userdata=None)
            time.sleep(1)
            print ("restarting offline module")
            for v in data_topic:
                print ("unsubscribing",v)
                mac = v[0:18].strip()
                v = v[18:len(v)-1]
                print(v)
                print(len(v))
                client.unsubscribe("/" + mac + v)
            time.sleep(1.5)
            ft = open("/home/odroid/Desktop/FinalPython/topics.txt", "r")
            data_topic_new = ft.readlines()
            ft.close()
            for v1 in data_topic_new:
                print ("new _ subscribing",v1)
                v1 = v1[18:len(v1)-1]
                print(v1)
                print(len(v1))
                client.subscribe(v1)
                print "printing status"
                v2 = v1 + "/status"
                client.subscribe(v2)
            fv = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
            data_mac2 = fv.readlines()
            del data_mac2[0:2]
            fv.close()
            #if len(data_mac2) > 0:
             #   for v1 in data_mac2:
              #      v1 = v1[-18:].strip()
               #     print v1
                #    client.subscribe("/lwt/" + v1)
            
        
        if msg.topic == "/wifi/scan":
            try:
                print (Search())
                publish.single(msg.topic + "/result",str(Search()),hostname=get_ip_address(),port=1883, client_id="qwer47sdfsdtytk",auth={'username':user,'password':passw})
            except:
                print ("Unable to update status")
        if msg.topic == "/wifi/ssid":
            global str_ssid
            str_ssid = msg.payload
            print ("SSID is ",str_ssid)

        if msg.topic == "/wifi/password":
            str_pass = msg.payload
            print ("Password is ",str_pass)
            try:
                call = 'sudo nmcli dev wifi connect "' + str_ssid + '" password ' + str_pass + ' name "' + str_ssid + '1"'
                cmd(call)
               # wireless = Wireless()
               # wireless.connect(ssid=str_ssid, password=str_pass)
            except:
                print ("unable to connect")
        if msg.topic == "/wifi/nopassword":
            str_pass = ""
            try:
                call = 'sudo nmcli dev wifi connect "' + str_ssid + '" password ' + str_pass + ' name "' + str_ssid + '1"'
                cmd(call)
              #  wireless.connect(ssid=str_ssid, password=str_pass)
            except:
                print ("unable to connect") #publish this notification
      #  if msg.topic.find("/lwt",0,5) == 0:
        if msg.topic == "/lwt":
            try:
                print " i have recieved a last will message"
                time.sleep(1)
                tcp_client_lwt(msg.payload.strip())
            except:
                print("failure at lwt")
                    
        if msg.topic == "/username/password":
             x1=msg.payload
             check = x1.find("*")
             username = x1[0:check].strip()
             print username
             passward = x1[check+1:len(x1)].strip()
             print passward
             #UP = open('/home/odroid/Desktop/FinalPython/authentication.txt', 'w')
             #UP.writelines(username +"\n" +passward)
             #UP.close()
             #Uz = open('/home/odroid/authentication.txt', 'w')
             #Uz.writelines(username)
             #Uz.close()
            # proc = subprocess.Popen(["sudo mosquitto_passwd /etc/mosquitto/pwfile ",username],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True)
             subprocess.check_call(['/home/odroid/Desktop/FinalPython/test.sh',username,passward])
             #proc.stdin.write(passward,"\r")
             #proc.stdin.write(passward,"\r")
             #proc.stdin.flush()
             #(out, err) = proc.communicate()
             #print out
             time.sleep(1)
             #subprocess.call("sudo service mosquitto stop ", shell=True)
             #subprocess.call("sudo service mosquitto start ", shell=True)
             #subprocess.call("sudo service mosquitto force-reload ", shell=True)
             #reboot client and mosquitto

        if msg.topic.find("/updatestatus",(msg.topic.find("/",(msg.topic.find("/") + 1)))) != -1:
            try:
                publish.single(msg.topic,msg.payload, hostname="videoupload.hopto.org",port=1234, client_id="qwersdfsdtytk",auth={'username':user,'password':passw})
            except:
                print("Unable to update status")
        if msg.topic.find("status") >= -1:
            dex=msg.topic.find("/status")
            new_topic= msg.topic[0:dex]
            print (new_topic)
            try:
                publish.single(new_topic,msg.payload, hostname="videoupload.hopto.org",port=1234, client_id="qwersdfssfsddtytk",retain=True,auth={'username':user,'password':passw})
            except:
                print("Unable to update switch status")
                publish.single(new_topic,msg.payload, hostname=get_ip_address(),port=1883, client_id="qwersdfssfsddtytk",retain=True,auth={'username':user,'password':passw})
   ####################################################
    
    
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message
    client.username_pw_set(user,passw)
    client.connect(get_ip_address(), 1883, 60)

    # Blocking call that processes network traffic, dispatches callbacks and
    # handles reconnecting.
    # Other loop*() functions are available that give a threaded interface and a
    # manual interface.
    client.loop_forever()
print("offline")
