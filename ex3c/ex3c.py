#!/usr/bin/env python

import sys
import numpy as np
import random

#if(len(sys.argv)<2):
#    print("Usage: python "+sys.arg[1]+" N W (test)")
#    sys.exit()

#N = int(sys.argv[2])
#if N==0:
#    N = random.randint(1,20)

lst =  [0,0,0,0,0,0,0,0,
	1,1,1,1,1,1,1,1,
	2,2,2,2,2,2,2,2,
	3,3,3,3,3,3,3,3,
	4,4,4,4,4,4,4,4,
	5,5,5,5,5,5,5,5,
	6,6,6,6,6,6,6,6]

fp = open("test.txt","w")

for i in range(0,7):
   for j in range(0,8):
      i = random.randint(0,len(lst)-1)
      N = lst.pop(i)
      fp.write(str(N))
      if(j<7):
	fp.write(" ")
   fp.write("\n")
fp.close()

