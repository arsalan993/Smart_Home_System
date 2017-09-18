# https://pymotw.com/2/sched/
# http://simeonfranklin.com/blog/2012/aug/14/scheduling-tasks-python/

import datetime
from astral import Astral
from astral import Location
from geopy.geocoders import Nominatim
import geocoder
import sched
import time
import socket
import datetime
from datetime import datetime as dt
import paho.mqtt.publish as publish
f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
data_UP = f1.readlines()
user = data_UP[0]
passw = data_UP[1].strip()
user = user[0:len(user)].strip()
f1.close()
print( user[0:len(user)].strip(),passw.strip())
def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]

def data_acq(a):
    print(a)
    print (time.time())
    with open("time.txt") as f:
        content = f.read()
        content = content.split('\n')
        f.close()
    print content
    #addr = raw_input("Please enter you city, state and country name : \n")
    addr = str(content[0])
    geolocator = Nominatim()
    location = geolocator.geocode(addr)
    print(location.address,"\n")
    print("Latitude : ",location.latitude)
    print("Longitude : ",location.longitude)
    g = geocoder.elevation([str(location.latitude), str(location.longitude)])
    print("Elevation : ",g.meters)

    print("-----------------------------------------")

    l = Location()
    l.name = addr
    l.region = addr
    l.latitude = location.latitude
    l.longitude = location.longitude
    l.timezone = 'Asia/Karachi'
    l.elevation = float(g.meters)
    print ("{:<12} {:<15} {:<10}".format('Phase','Date','Time'))
    for i in l.sun().keys():
        print("{:<12} {:<15} {:<10}".format(str(i),str(l.sun()[i].date()),str(l.sun()[i].time())))

    print("-----------------------------------------")
    t1 = (str(l.sun()["sunrise"].date()) +" "+ str(l.sun()["sunrise"].time()))
    print (t1)
    t2 = (str(l.sun()["sunset"].date()) +" "+ str(l.sun()["sunset"].time()))
    print (t2)
    print ("sunrise min", time.mktime(datetime.datetime.strptime(t1, "%Y-%m-%d %H:%M:%S").timetuple()))
    print ("sunset min", time.mktime(datetime.datetime.strptime(t2, "%Y-%m-%d %H:%M:%S").timetuple()))
    
    schedular(t1,t2)
    

def sunset(a):
    print (a)
    print (time.time())
    with open("time.txt") as f:
        content = f.read()
        content = content.split('\n')
        f.close()
        if content[1][8:].strip() == 'enable':
            publish.single("/room3/switch2", "sw-on", qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch1 is disable"
        if content[2][8:].strip() == 'enable':
            publish.single("/room3/switch3", "sw-on", qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch2 is disable"
        if content[3][8:].strip() == 'enable':
            publish.single("/room3/switch5", "sw-on", qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch3 is disable"
            
       
        
def sunrise(a):
    print (a)
    print (time.time())
    with open("time.txt") as f:
        content1 = f.read()
        content1 = content1.split('\n')
        f.close()
        if content1[1][8:].strip() == 'enable':
            publish.single("/room3/switch2", "sw-off",  qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch1 is disable"
        if content1[2][8:].strip() == 'enable':
            publish.single("/room3/switch3", "sw-off",  qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch2 is disable"
        if content1[3][8:].strip() == 'enable':
            publish.single("/room3/switch5", "sw-off",  qos=2, retain=True, hostname= get_ip_address(),port=1883, client_id="deamon", keepalive=60, will=None, auth = {'username':user.strip(), 'password':passw.strip()})
        else :
            print "switch3 is disable"
        


def schedular(t1,t2):
    now = time.time()
    
    #print type(t1)
    t1 = time.mktime(datetime.datetime.strptime(t1, "%Y-%m-%d %H:%M:%S").timetuple())
    t2 = time.mktime(datetime.datetime.strptime(t2, "%Y-%m-%d %H:%M:%S").timetuple())
    #print "sunrise time is ", type(t1)
    #print "sunset time is ", type(t2)
    #print "value of now is", type(now)
    #print ("lolz", time.mktime((2016,12,13,12,14,00,00,00,00)))
    
    scheduler = sched.scheduler(time.time, time.sleep)
    if t1 > now:
        scheduler.enterabs(t1, 1, sunrise, "a")
        print("2")
    if t2 > now:
        scheduler.enterabs(t2, 2, sunset, "b")
        print("1")
    daily_time = datetime.time(1)
    #print ("daily time", daily_time)
    first_time = str(dt.combine(dt.now() + datetime.timedelta(days=1), daily_time))
    #print (type(first_time))
    first_time = time.mktime(datetime.datetime.strptime(first_time, "%Y-%m-%d %H:%M:%S").timetuple())
    #print (first_time)
    scheduler.enterabs(first_time, 3, data_acq, "d")
    scheduler.run()
    print ("schedular started")
    


