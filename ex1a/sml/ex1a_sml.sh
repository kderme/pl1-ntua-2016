#!/bin/bash

#error_counter=0
while true
do
python rnd.py 0 test
./find test.txt
if [ $? != 0 ]; 
then
	echo "find ERROR">>log
	cp test.txt wrong
	exit
fi
./revsum found.test.txt >res.found.test.txt
if [ $? != 0 ]; 
then
	echo "revsum ERROR">>log
	cp test.txt wrong
	exit
fi

./find res.found.test.txt
if [ $? != 0 ]; 
then
	echo "find2 ERROR">>log
	cp test.txt wrong
	exit
fi
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
