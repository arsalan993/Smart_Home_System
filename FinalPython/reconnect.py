from new import *
import sys
import socket
import fcntl
import struct
import array
import time
import subprocess
import time
temp = 0
counter = 0
import socket

def all_interfaces():
    is_64bits = sys.maxsize > 2**32
    struct_size = 40 if is_64bits else 32
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    max_possible = 8 # initial value
    while True:
        bytes = max_possible * struct_size
        names = array.array('B', '\0' * bytes)
        outbytes = struct.unpack('iL', fcntl.ioctl(
            s.fileno(),
            0x8912,  # SIOCGIFCONF
            struct.pack('iL', bytes, names.buffer_info()[0])
        ))[0]
        if outbytes == bytes:
            max_possible *= 2
        else:
            break
    namestr = names.tostring()
    return [(namestr[i:i+16].split('\0', 1)[0],
             socket.inet_ntoa(namestr[i+20:i+24]))
            for i in range(0, outbytes, struct_size)]
def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]
def router_c():
    temp = 0
    while 1:
        try :
            temp1 = 1
            while 1:
                
                if len(all_interfaces()) > 1:
                    matching = [s for s in all_interfaces() if get_ip_address() in s]
                    if matching == []:
                        print ("not found")
                        
                    else:
                        if temp1 == 1:
                            print (matching)
                            Data_Forward()
                            temp1 = 0
                       
                else:
                    print ("local server offline")
                    temp1 = 1
                time.sleep(6)
        except:
            print ("failed")
            

