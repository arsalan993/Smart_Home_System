
with open("time.txt") as f:
    old =  f.read()
    old = old.split('\n')
    for u in old:
        print u

print old[1]
