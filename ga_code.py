#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import base64
import time
import hmac
from hashlib import sha1
import struct

try:
    INPUT = sys.argv[1]
except Exception,e:
    print("ERROR: secretkey no set.")
    exit()
INPUT = INPUT.strip()
try:
    key = base64.b32decode(INPUT,True)
except Exception,e:
    print e
    exit()

tm = time.time()/30
 # int to bytes,q:long long,>:big-endian
value = struct.pack(">q", tm)
hm = hmac.new(key,value,sha1).digest()
offset = ord(hm[-1]) & 0x0F
truncatedHash = hm[offset:offset+4]

code = struct.unpack(">L", truncatedHash)[0]
code &= 0x7FFFFFFF
code %= 1000000

print code
