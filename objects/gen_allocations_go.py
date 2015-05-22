#!/usr/bin/env python
import requests
import yaml
import sys

rq = requests.get("https://raw.githubusercontent.com/immesys/bw2_pid/master/allocations.yaml")
if rq.status_code != 200:
    print "Could not obtain allocations file from GitHub"
    sys.exit(1)

doc = yaml.load(rq.text)

def parsedot(s):
    i = s.split(".")
    return (int(i[0])<<24) + (int(i[1])<<16) + (int(i[2]) << 8) + int(i[3])

subnets = sorted([(int(k.split("/")[1]), parsedot(k.split("/")[0]), k ) for k in doc.keys()])

for i in subnets:
    print i
