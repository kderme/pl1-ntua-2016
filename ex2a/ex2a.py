import random
import sys

def random_deksameni():
  b = random.randint(1,1000000)
  p = random.uniform(0,1)
  if p < 0.8:
    x = random.randint(1,34) 
#34 = third square root of 42000. We give 0.8 chances in that interval. Make it less for tall deksamenes
  elif p < 0.9:
    x = random.randint(1,250)
  else:
    x = random.randint(1,42000)
  h = x		
  w = random.randint(1,42000/h)
  l = random.randint(1,42000/(h*w))
  return (b,h,w,l)

generated = open('test.txt', 'w')
N = random.randint(1,420000)

generated.write(`N`+'\n')

for i in range(N):
  (a,b,c,d)=random_deksameni()
  generated.write(`a`+' '+`b`+' '+`c`+' '+`d`+'\n')
generated.write(`random.randint(1,N*42000)`) 

# generated.write(`random.randint(1,N*21000)`) this gives low chances for overflow
