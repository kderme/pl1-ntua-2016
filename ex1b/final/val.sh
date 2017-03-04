#while true 
#do
python ex1b.py
if [ $? != 0 ];
then
	echo "python terminated"
        exit
fi

#./find test.txt
#if [ $? != 0 ];
#then
#        echo "find ERROR">>log
#        cp test.txt wrong
#        exit
#fi
valgrind --leak-check=full -v ./a.out test.txt>test.c.txt
#./a.out test.txt >res.found.test.txt
if [ $? != 0 ];
then
        echo "a.out ERROR">>log
        cp test.txt wrong
        exit
fi
#done
#./find res.found.test.txt
#if [ $? != 0 ];
#then
#        echo "find2 ERROR">>log
#        cp test.txt wrong
#        exit
#fi
#if diff "found.test.txt" "found.res.found.test.txt" >/dev/null ;
#then
#        :
#else
 #       echo "FIles are NOT same ERROR">>log
  #      echo $(wc -c found.test.txt)
   #     echo $(wc -c found.res.found.txt)
#        cp test.txt wrong
#        exit
#fi

