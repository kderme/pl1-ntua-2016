#!/usr/bin/env python

import sys
import numpy as np
import random

if(len(sys.argv)<2):
    print("Usage: python "+sys.arg[1]+" N W (test)")
    sys.exit()

N = int(sys.argv[2])
if N==0:
    N = random.randint(1,20)

W = int(sys.argv[3])
if W==0:
    W = random.randint(1,20)
     

if(len(sys.argv)==3)
    output = "test.txt"

else:
    output = sys.argv[4]+".txt"

fp = open(output,"w")

fp.write(str(N))

fp.write(str(W))

fp.write("\n")

fp.close()

