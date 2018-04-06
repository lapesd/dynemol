# Scripts

This file contains documentation of the scripts created in the [scripts](../scripts) folder.


## test.sh

Timing utility to test the performance of some program.

It is a very simple program. It creates a file, runs the `time` utility with the command provided and saves the results. In the end, makes the average of all these results and prints to the user.


### Usage

It is possible to use it for any program/command. But, for the software we want to test, it is necessary to run it from inside the [dynemol](../dynemol) folder.

```bash
bash test.sh (count) (program) [args]
```
  - **count**: number of times we want to run the _program_
  - **program**: program we want to run
  - **args**: command line arguments to be passed to _program_


### Output

Prints info related to the time that takes to run the program. Also, performs an average calculation between all the run times.


### Example

```bash
>$ sh scripts/test.sh 10 sleep 1
Times for each run:
	 1	1.009
	 2	1.009
	 3	1.010
	 4	1.010
	 5	1.010
	 6	1.010
	 7	1.010
	 8	1.010
	 9	1.010
	10	1.009

Medium of runs:
1.009
```
