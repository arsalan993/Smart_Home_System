import subprocess
import time
import socket
from reconnect import *
import platform, os, logging
import os
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
    hostname = "videoupload.hopto.org" #example
    response = os.system("ping -c 1 " + hostname)
    print response
    if response==0:
        subprocess.call("/home/odroid/Desktop/FinalPython/timeset.sh")
        break
    else:
        print ("no internet")
