##
##import subprocess
##import time
##
##proc = subprocess.Popen(["sudo mosquitto_passwd -c /etc/mosquitto/pwfile arsalan993"],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=True)
##proc.stdin.write("12345\n")
##proc.stdin.write("12345\n")
##proc.stdin.flush()
##(out, err) = proc.communicate()
##
##print(out)
##print(err)
##
##
##f1 = open("authentication.txt", "r")
##data_UP = f1.readlines()
##user = data_UP[0]
##passw = data_UP[1]
##user = user[0:len(user)-1]
##f1.close()
##
##print( user[0:len(user)-1],passw)
##import time
##from mosquitto_o import *
##from Mosquitto_1 import *
##
##exitFlag = 0
##
##offline1()

t = "arsa : 12:43:141"+"\n"+"arsa : 12:43:141"+"\n"+"arsa : 12:43:141"+"\n"
print t
t = t.split("\n")
for n in t:
    print n
