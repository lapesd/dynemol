
# Print help
if [ $1 == '-h' ]
then
	echo "Usage:"
	echo "test (times) (command) [args]"
	echo ""
	echo "	times: integer of how many times want to run command"
	echo "	command: command to be run"
	echo "	args: command line arguments to be passed to command"
	echo ""
	echo "Example:"
	echo "	$> test 2 sleep 1"
	echo "	> Times for each run:"
	echo "	>      1	1.011"
	echo "	>      2	1.010"
	echo "	>"
	echo "	> Medium of runs:"
	echo "	> 1.010"
	echo ""
	exit 0
fi

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
