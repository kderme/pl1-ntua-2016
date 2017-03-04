#!/bin/bash

while true 
do
N=20 #$(( ( RANDOM % 10 ) +1 ))
Wa=$(( ( RANDOM % 100000 ) +1 ))
Wb=$(( ( RANDOM % 100000 ) +1 ))
echo $N
echo $Wa$Wb
./balance $N "$Wa$Wb">sml.out
if [ $? != 0 ];
then
        echo "sml ERROR"
        exit
fi
cat sml.out

java Balance $N "$Wa$Wb">java.out
if [ $? != 0 ];
then
        echo "java ERROR"
        exit
fi
cat java.out

if diff "sml.out" "java.out" > /dev/null ;
then
	:
else
	echo "files are different ERROR">>log
	cp test.txt wrong.txt
	exit
fi
done
