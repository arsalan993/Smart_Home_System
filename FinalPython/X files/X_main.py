from new import *
import time
proc = subprocess.Popen(["sudo arp-scan -l --destaddr=" + addr], stdout=subprocess.PIPE, shell=True)
(out, err) = proc.communicate()
#print("program output:", out)
new_out = out.decode('ASCII')

