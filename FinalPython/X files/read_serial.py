#!/usr/bin/env python
from new import *
import time
import serial
import socket

ind = 0
temp_str = []
ser = serial.Serial(
              
    port='COM3', #set this to com port + number
    baudrate = 9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    bytesize=serial.EIGHTBITS,
    timeout=1
    )
counter=0

while 1:
    x=ser.readline()
    
    new_out = x.decode('cp1252')
    if not x:
        x = ''
        
    else:
        S_check = new_out.find('START')
        E_check = new_out.find('END')
        if (S_check != -1) and (E_check == -1):
            print("Start")
            print(new_out)
            temp_str.append(new_out[7:len(new_out)])
        elif (S_check == -1) and (E_check != -1):
            print("END")
            #Writing Data to a file
            FileWriting(temp_str)
            time.sleep(1)
            temp_str = []
            Data_Acquisition()
        else:
            print("invalid Data")
                                              
            
        
   
