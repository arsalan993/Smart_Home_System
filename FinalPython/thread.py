import threading
import time
from mosquitto_o import *
from Mosquitto_1 import *
from reconnect import *
import platform, os, logging
import subprocess, pexpect
from datascience import *


exitFlag = 0

class online_1 (threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
    
    def run(self):
        print ("Starting online")
        while 1:
            try:
                online1()
                break
            except:
                print ("online server not availabe")
                time.sleep(1)
        print ("Exiting online" )

class offline_1 (threading.Thread):
     def __init__(self):
         threading.Thread.__init__(self)

     def run(self):
         print ("Starting offline")
         while 1:
            try:
                offline1()
                break
            except:
                print ("offline server not availabe")
                time.sleep(1)
         print ("Exiting offline" )
class TimeCheck (threading.Thread):
     def __init__(self):
         threading.Thread.__init__(self)

     def run(self):
         print ("Starting offline")
         while 1:
            try:
                data_acq("a")
                break
            except:
                print ("Geo Locator server offline")
                time.sleep(1)
         print ("Exiting offline" )

class Router_check (threading.Thread):
     def __init__(self):
         threading.Thread.__init__(self)

     def run(self):
         print ("checking router")
         while 1:
            try:
                router_c()
                #break
            except:
                print ("offline server not availabe")
                time.sleep(1)
                print ("Exiting offline" )

new_temp = 0
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
#thread1 = TimeCheck()

thread2 = offline_1()

thread3 = online_1()

thread4 = Router_check()
#thread1.start() # This actually causes the thread to run
thread2.start()
thread3.start()
thread4.start()
time.sleep(1.1)
#thread1.join()  # This waits until the thread has completed
time.sleep(1.3)
thread2.join()
time.sleep(1.5)
thread3.join()
time.sleep(1.7)
thread4.join()
# At this point, both threads have completed

print("exiting thread")
