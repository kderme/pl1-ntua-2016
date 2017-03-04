#!/bin/bash

#error_counter=0
while true
do

#create random
python rnd.py 0 test

#find its revsum
./find test.txt
if [ $? != 0 ]; 
then
	echo "find ERROR">>log
	cp test.txt wrong
	exit
fi

#run program to find if it has a revsum (it should have)
./a.out found.test.txt >res.found.test.txt
if [ $? != 0 ]; 
then
	echo "a.out ERROR">>log
	cp test.txt wrong
	exit
fi

#find its revsum
./find res.found.test.txt
if [ $? != 0 ]; 
then
	echo "find2 ERROR">>log
	cp test.txt wrong
	exit
fi

#test if result is the same as initial
if diff "found.test.txt" "found.res.found.test.txt" >/dev/null ;
then 
	:
else
	echo "FIles are NOT same ERROR">>log
	echo $(wc -c found.test.txt)
	echo $(wc -c found.res.found.txt)
	cp test.txt wrong
	exit
fi
done
