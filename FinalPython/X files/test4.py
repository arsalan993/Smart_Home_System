f2 = open("/home/odroid/Desktop/FinalPython/data1.txt", "r")
data_mac = f2.readlines()

for u in data_mac:
    print u[-18:]," ",len(u[-18:].strip())

