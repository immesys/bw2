#!/usr/bin/env python
import os
import boto
import sys
import re
import hashlib
from boto.s3.key import Key
from boto.s3.bucket import Bucket
import ssl
import yaml

_old_match_hostname = ssl.match_hostname

def _new_match_hostname(cert, hostname):
   if hostname.endswith('.s3.amazonaws.com'):
      pos = hostname.find('.s3.amazonaws.com')
      hostname = hostname[:pos].replace('.', '') + hostname[pos:]
   return _old_match_hostname(cert, hostname)

ssl.match_hostname = _new_match_hostname

if len(sys.argv) != 2:
    print "usage: publish_installer <version>"
    sys.exit(1)
ver = sys.argv[1]
if not re.compile("\\d+\\.\\d+\\.\\d+").match(ver):
    print "version number mismatch, expect x.x.x"
    sys.exit(1)

conn = boto.connect_s3()
buck = Bucket(conn, "get.bw2.io")

template = open(os.path.join(os.path.dirname(os.path.realpath(__file__)),"agent")).readlines()
repld = []
for l in template:
    if "REPLACE_THIS" in l:
        repld.append("REL="+ver+"\n")
    else:
        repld.append(l)
installer = "".join(repld)

k = Key(buck)
k.key = "agent"
k.set_contents_from_string(installer)
print "uploaded installer"
