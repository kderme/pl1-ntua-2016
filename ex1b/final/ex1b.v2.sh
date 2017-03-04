#!/bin/bash


python ex1b.py 10
cat test.txt
./a.out test.txt>test.c.txt
if [ $? != 0 ];
then
        echo "a.out ERROR"
        exit
fi
cat test.c.txt
