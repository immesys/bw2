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

if len(sys.argv) != 5:
    print "usage: release <version> <platform> <arch> <path>"
    sys.exit(1)
ver = sys.argv[1]
plat = sys.argv[2]
arch = sys.argv[3]
loc = sys.argv[4]
if loc[-1] != "/":
    loc += "/"
if not re.compile("\\d+\\.\\d+\\.\\d+").match(ver):
    print "WARN version number mismatch, expect x.x.x"
    #sys.exit(1)
if plat not in ["windows","darwin","linux"]:
    print "platform mismatch, expect windows,darwin,linux"
    sys.exit(1)
conn = boto.connect_s3()
buck = Bucket(conn, "get.bw2.io")
# buck = conn.create_bucket("get.bw2.io")
# mfkey = "bw2/2.x/%s/%s/manifest.yaml" % (plat, arch)
# rem_mf = Key(buck)
# rem_mf.key = mfkey
# existing_mf_contents = rem_mf.get_contents_as_string()
# mf = yaml.load(existing_mf_contents)
# if mf is None:
#    print "WARN, empty manifest"
#    mf = {}

remote_path = "bw2/2.x/%s/%s/%s/" % (plat, arch, ver)

#def md5(fname):
#    hash_md5 = hashlib.md5()
#    with open(fname, "rb") as f:
#        for chunk in iter(lambda: f.read(4096), b""):
#            hash_md5.update(chunk)
#    return hash_md5.hexdigest()

def put(local, remote):
    realremote = remote_path+remote
    k = Key(buck)
    k.key = realremote
    print "uploading:",realremote,
    def oncb(done,total):
        sys.stdout.write(".")
        sys.stdout.flush()
    k.set_contents_from_filename(local,cb=oncb, num_cb=20)
    print "\n",

for root, dirs, files in os.walk(loc):
    relname = root[len(loc):]
    for f in files:
        put(os.path.join(root,f), f)
