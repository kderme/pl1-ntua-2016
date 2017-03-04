#!/usr/bin/env python

import sys
import numpy as np
import random

if(len(sys.argv)!=3):
    print "Usage: python " + sys.argv[0] + " length filename"
    exit()

LENGTH = int(sys.argv[1])

if LENGTH==0:
    LENGTH = random.randint(3,100000)
     
fp = open(sys.argv[2]+".txt",'w')

digit=random.randint(1,9)
fp.write(str(digit))
for i in xrange(LENGTH-1):
    digit=random.randint(0,9)
    fp.write(str(digit))

fp.write("\n")
fp.close()

