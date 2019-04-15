#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: ./grade.sh MAXPOINTS"
else
    echo "Grading with a max score of $1"
    echo
    MAXSCORE=$1 
	tar xvzf students.tar.gz -C .>garbage.txt	#unzip files
	rm garbage.txt	#unneccessary files remove it 
	
    for studentid in `ls students/`; do
	echo "Processing $studentid ..."
	cd students/$studentid/
	if [ -e homework1.sh ]; then 
	    bash ./homework1.sh > output.txt  #run the command and write
	    cd .. && cd ..

	    X=`diff -bEBw expected.txt ./students/$studentid/output.txt | grep "[<>]" | wc -l`		#count the different lines
            
	    if [ $X -gt 0 ]; then
		echo "$studentid has $X lines incorrect output"
	    else
		echo "$studentid has correct output"
	    fi
	  
	    ((tempScore=$MAXSCORE - $X))  

	    Y=$(egrep "#" ./students/$studentid/homework1.sh | wc -l)	#use the regex to find number of comments
		echo "$studentid has $Y lines with comments"  

	    if [ $Y -ge 3 ]; then  
		FINALSCORE=$tempScore	#if it is satisfied to number of comments condition than assign the directly
	    else
		((FINALSCORE=$tempScore - 5))	#if it is not 
	    fi

	    if [ $FINALSCORE -ge 0 ]; then  
		echo "$studentid has earned a score of $FINALSCORE / $MAXSCORE"
	    else
		echo "$studentid has earned a score of 0 / $MAXSCORE"
	    fi
	else
	    echo "$studentid did not turn in the assignment"
	    echo "$studentid has eanred a score of 0 / $MAXSCORE"
	    cd .. && cd ..
	fi
	echo
    done
fi
