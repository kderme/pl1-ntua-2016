import random
import sys

def random_deksameni(max):
  b = random.randint(1,1000000)
  
  h = random.randint(1,max)
  w = random.randint(1,max/h)
  l = random.randint(1,max/(h*w))
  return (b,h,w,l)

generated = open('test.txt', 'w')
N = random.randint(1,420000)

generated.write(`N`+'\n')
p = random.uniform(0,1)
if p < 0.5:
  max = 1
elif p < 0.8:
  max = 12 
elif p < 0.9:
  max = random.randint(1,100)
else:
  max = random.randint(1,500)
print(max)
for i in range(N):
  (a,b,c,d)=random_deksameni(max)
  generated.write(`a`+' '+`b`+' '+`c`+' '+`d`+'\n')
generated.write(`random.randint(1,N*max)`) 

# generated.write(`random.randint(1,N*21000)`) this gives low chances for overflow
