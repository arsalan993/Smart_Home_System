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
    print("encoded data or empty", x)
    new_out = x.decode('cp1252')
    if not x:
        x = ''
        
    else:
        print(x)
                                              
            
        
   
