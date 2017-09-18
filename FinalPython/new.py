import subprocess
import time
import re
temp = 0
counter = 0
import socket
def my_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    return s.getsockname()[0]
#Below function do ARP Scanning
def ARPScanner(addr):
    print ("ARP scanning the address", addr)
    lineList = None
    start = 0
    proc = subprocess.Popen(["sudo arp-scan --interface=wlan0 -l --destaddr=" + addr], stdout=subprocess.PIPE, shell=True)
    (out, err) = proc.communicate()
    #print("program output:", out)
    new_out = out.decode('ASCII')
    print("address=",addr)
    start = new_out.find(addr)
    print(new_out," 12345" ,start)
    if (start != -1):
        lineList = new_out.split('\n')
        print("line List = ",lineList)
        newline=lineList[2]
        print("newline = ",newline)
        #newstart = newline.find(addr)
        #print(newstart)
        #newstr=newline[0:newstart]
        newstr = re.search(r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',newline).group()
        print(newstr)
        print(len(newstr))
        newstr = newstr.strip(' \t\n\r')
        print(len(newstr))
        return newstr
    elif start == -1:
        print("Mac Adress cant be accessed")

#Below function Takes IP from ARP Scanner and writes Device name, IP, MacAddress
#and Writes this data into Data 1 file
def Data1Writing (device_name, IP, addrnew):
    if (IP != None):
        fo = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
        data = fo.readlines()
        data_len = len(data)
        for num in range(0,data_len):
            #print(num,":",data_len)
            check = data[num].find(addrnew)
            print (check)
            if(check != -1):
                data[num]= device_name + "<" + IP + ">" + addrnew + "\n"
                fo = open('/home/odroid/Desktop/FinalPython/data1.txt', 'w')
                fo.writelines( data)
                print("trim addr")
                fo.close() 
                num = 0;
                check = 0;
                break
            #elif check == -1:
            if num == data_len-1:
                fo = open('/home/odroid/Desktop/FinalPython/data1.txt', 'a')
                fo.write(device_name + "<" + IP + ">" + addrnew + "\n")
                print("new addr")
                fo.close() 
            else:
                 continue
            
        return
#this function reads data from data 2 file and for each data we perform ARP scan
def Data2Reading (index):
    fo = open("/home/odroid/Desktop/FinalPython/data2.txt", "r")
    data = fo.readlines()
    data_len = len(data)
    
    if (data_len >= 1) and (data != []):
        seperator = data[index].find(' : ')
        str_len = len(data[index])
        new_str = data[index]
        Device_name = new_str[0 : seperator]
        #print(Device_name)
        Device_name = Device_name.strip(' \t\n\r')
        #print(Device_name)
        Device_addr = new_str[seperator+3 : str_len-1]
        #print(Device_addr)
        Device_addr = Device_addr.strip(' \t\n\r')
        #print(Device_addr)
        return (data_len,Device_name,Device_addr)
    elif (data_len == 0) and (data == []):
        Device_name = None
        Device_addr = None
        return (data_len,Device_name,Device_addr)

#this function will write data recieved from user via hub esp 
#and writes it DATA2 files a
def FileWriting (StrData):
    temp = 0
    fo = open('/home/odroid/Desktop/FinalPython/data2.txt', 'w')
    for items in StrData:
        fo.write("%s" % items)
        temp = temp +1
        print("counter = ",temp)
    fo.close() 

def Data1_Reading(index):
    fo = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
    data = fo.readlines()
    data_len = len(data)
    
    if (data_len >= 1) and (data != []):
        seperator1 = data[index].find('<')
        seperator2 = data[index].find('>')
        str_len = len(data[index])
        new_str = data[index]
        Device_name = new_str[0 : seperator1]
        #print(Device_name)
        Device_name = Device_name.strip(' \t\n\r')
        print(Device_name)
        Device_ip = new_str[seperator1+1 : seperator2]
        #print(Device_addr)
        Device_ip = Device_ip.strip(' \t\n\r')
        print(Device_ip)
        Device_addr = new_str[seperator2+1 : str_len-1]
        
        Device_addr = Device_addr.strip(' \t\n\r')
        print(Device_addr)
        return (data_len,Device_name,Device_ip,Device_addr)
    elif (data_len == 0) and (data == []):
        Device_name = None
        Device_ip = None
        Device_addr = None
        return (data_len,Device_name,Device_ip,Device_addr)
    
#this function send hub ip to esp via tcp
def tcp_client (index):
    counter = 0
    print("Entered TCP client")
    for num in range(1,index-1):
        print(num)
        ind,name,ip,mac = Data1_Reading(num)
        print(ip)
        for num1 in range(0,2):
            print("ip address=",ip)
            TCP_IP = ip
            TCP_PORT = 325
            BUFFER_SIZE = 1024
            f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
            data_UP = f1.readlines()
            user = data_UP[0]
            passw = data_UP[1].strip()
            print (passw)
            user = user[0:len(user)].strip()
            print (user)
            f1.close()
            MESSAGE ="ASDFG"+my_ip_address() + '/' + user + '/' + passw + '\n'
            MESSAGE = MESSAGE.encode('cp1252')
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s =  socket.socket()
                s.settimeout(5)
                s.connect((TCP_IP, TCP_PORT))
                print("sending message")
                s.send(MESSAGE)
                s.close()
                temp = 1
            except:
                print('Error occured')
                temp = 0
            
            if temp == 1:
                print('Data Send on',ip)
                fo = open('/home/odroid/Desktop/FinalPython/topics.txt', 'r')
                data = fo.readlines()
                data_len = len(data)
                fo.close()
                for num in range(0,data_len):
                   #print(num,":",data_len)
                     check = data[num].find(mac)
                     print("check =",check)
                     
                     if(check != -1):
                         print("writing to topic file old topics")
                         counter = counter + 1
                         data[num]= mac + " " + "/" + name + "/switch" + str(counter) +"\n"
                         fo = open('/home/odroid/Desktop/FinalPython/topics.txt', 'w')
                         fo.writelines( data)
                         print("trim addr")
                         fo.close() 
                        #num = 0;
                         check = 0;
                         if(counter == 6):
                             counter = 0
                             break
                        #break
                     if num == data_len-1:
                         print("writing to topic file new topics")
                         newfo = open('/home/odroid/Desktop/FinalPython/topics.txt', 'a')
                         for num1 in range(1,7):
                             
                             newfo.write(mac + " " + "/" + name + "/switch" + str(num1) +"\n")
                             print("new addr")
                         fo.close()    
                         break
                     
                     else:
                       continue
                break
            elif temp == 0:
                print('Unable to Send data on',' ',ip)
            time.sleep(1.5)

def Data_Acquisition():
    x= Data2Reading(0)
    print("initial index data2reading",x[0])
    for numb in range(0,x[0]):
        inx,dev_name,MACad = Data2Reading(numb)
        device_name1 = dev_name
        addrnew1 = MACad
        print ("address read from file", addrnew1)
        print("after data acquisition",addrnew1)
        #scan for ip
        for i in range(0,3):
            IP1 = ARPScanner(addrnew1) #for lopped it 3 times
            #print(IP1)
            time.sleep(1.5)
            print("empty")
            if IP1 != None:
                print(" not empty")
                #writing the ip
                print ("enter Data writing function")
                Data1Writing (device_name1, IP1, addrnew1)
                break
            elif IP1 == None:
                continue
    #reading ip data
    print("Entering TCP function")
    n= Data2Reading(0)
    print("number of users",n[0])
    temper = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
    data2 = temper.readlines()
    data_len2 = len(data2) -1
    temper.close()
    tcp_client (n[0]+data_len2)

def Data_Forward():
    x= Data1_Reading(0)
    print("initial index data2reading",x[0])
    for numb in range(1,x[0]):
        inx,dev_name,ip_n,MACad = Data1_Reading(numb)
        device_name1 = dev_name
        addrnew1 = MACad
        print ("address read from file", addrnew1)
        print("after data acquisition",addrnew1)
        #scan for ip
        for i in range(0,3):
            IP1 = ARPScanner(addrnew1) #for lopped it 3 times
            #print(IP1)
            time.sleep(1.5)
            print("empty")
            if IP1 != None:
                print(" not empty")
                #writing the ip
                print ("enter Data writing function")
                Data1Writing (device_name1, IP1, addrnew1)
                break
            elif IP1 == None:
                continue
    #reading ip data
    print("Entering TCP function")
   #n= Data2Reading(0)
   # print("number of users",n[0])
    temper = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
    data2 = temper.readlines()
    data_len2 = len(data2) 
    temper.close()
    tcp_client (data_len2 + 1)



def tcp_client_lwt (ip_mac):
    counter = 0
    time.sleep(3)
    ip = ARPScanner(ip_mac)
    for num1 in range(0,2):
            print("ip address=",ip)
            TCP_IP = ip
            TCP_PORT = 325
            BUFFER_SIZE = 1024
            f1 = open("/home/odroid/Desktop/FinalPython/authentication.txt", "r")
            data_UP = f1.readlines()
            user = data_UP[0]
            passw = data_UP[1].strip()
            print (passw)
            user = user[0:len(user)].strip()
            print (user)
            f1.close()
            MESSAGE ="ASDFG"+my_ip_address() + '/' + user + '/' + passw + '\n'
            MESSAGE = MESSAGE.encode('cp1252')
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s =  socket.socket()
                s.settimeout(5)
                s.connect((TCP_IP, TCP_PORT))
                print("sending message")
                s.send(MESSAGE)
                s.close()
                temp = 1
            except:
                print('Error occured')
                temp = 0
            
            if temp == 1:
                print('Data Send on',ip)
                break
            elif temp == 0:
                print('Unable to Send data on',' ',ip)
            time.sleep(1)
