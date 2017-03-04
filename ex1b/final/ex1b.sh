#!/bin/bash


while true
do
python ex1b.py

./a.out test.txt>test.c.txt
if [ $? != 0 ];
then
        echo "a.out ERROR">>log
        cp test.txt wrong.txt
        exit
fi

./fair_parts test.txt>test.sml.txt
if [ $? != 0 ];
then
        echo "fair_parts ERROR">>log
        cp test.txt wrong.txt
        exit
fi

#file1=`md5 "test.c.txt"`
#file2=`md5 "test.sml.txt"`
if diff "test.c.txt" "test.sml.txt" > /dev/null ;
then
	:
else
	echo "files are different ERROR">>log
	cp test.txt wrong.txt
	exit
fi
done
