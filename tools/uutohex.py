#!/usr/bin/env python
import sys
import base64

h = ""
for i in base64.urlsafe_b64decode(sys.argv[1]):
  h += "%02x" % ord(i)

print h
