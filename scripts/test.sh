#!/bin/bash

# File where times will be stored
TEMP_FILE='times.txt'
touch $TEMP_FILE

# Gets program (everything after first argument)
PROGRAM="${@:2}"

# I just want the real time
TIMEFORMAT="%E"
for (( i=0; i<$1; i++ ))
do
	{ time ( $PROGRAM > /dev/null ) ; } 2>> $TEMP_FILE
done

# Show times
echo "Times for each run:"
cat -n $TEMP_FILE
echo

# Sum everything
TOTAL_TIME=`paste -sd+ times.txt | bc`
TOTAL_RUNS=`wc -l < times.txt`

# Show result
echo "Medium of runs:"
echo "scale=3; $TOTAL_TIME / $TOTAL_RUNS" | bc

# Clean up
rm $TEMP_FILE
