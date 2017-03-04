#!/bin/bash


while true
do
echo "new test"
python ex2a.v2.py

java Deksamenes test.txt>test.java.txt
if [ $? != 0 ];
then
        echo "java ERROR">>log
        cp test.txt wrong.txt
        exit
fi
cat test.java.txt

./deksamenes test.txt>test.sml.txt
if [ $? != 0 ];
then
        echo "sml ERROR">>log
        cp test.txt wrong.txt
        exit
fi
cat test.sml.txt

#file1=`md5 "test.c.txt"`
#file2=`md5 "test.sml.txt"`
if diff "test.java.txt" "test.sml.txt" > /dev/null ;
then
	:
else
	echo "files are different ERROR">>log
	cp test.txt wrong.txt
	exit
fi
done
