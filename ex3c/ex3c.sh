#!/bin/bash

while true 
do
python ex3c.py
./a.out test.txt>out.txt
cat out.txt

if diff "out.txt" "zero.txt" >/dev/null ;
then
	:
else 
	echo "found"
	cat test.txt>>tests.txt
	cat out.txt>>tests.txt
#       exit
fi

done
