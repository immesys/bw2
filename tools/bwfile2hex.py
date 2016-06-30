import sys

f = open(sys.argv[1],"r").read()

if ord(f[0]) == 0x32:
    #signing entity. Drop the Key
    
    f = f[33:]
else:
    #just drop the ronum
    f = f[1:]
    
h = ""
for i in f:
    h += "%02x"% ord(i)

while len(h) > 0:
    print "\""+h[:64]+"\"+"
    if len(h) >64:
        h = h[64:]
    else:
        h = ""
