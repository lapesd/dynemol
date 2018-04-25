# Tests

Description of some tests created to check for the expected performance improvements when using some technique.


## Why?

First of all, there need to be a basis parameter to check for performance increases/decreases. This basis parameter, in this project, is the software received, _as is_, with all the OMP directives removed.

- By _as is_, it is meant with little modifications. The only ones made where the removal of the `pure` keyword and commenting an import. Both of them in [DP_main.f](../dynemol/DP_main.f). After further discussion with the teacher, the errors it gave were probably because of compilers' versions.


## OMP Removal

The first tests were performed with the software _as is_, but it was not possible to conclude much from it. When checking the runtime of threads, it was noted that many threads were created, but not by the procedures that were being analyzed. This left space for confusion.

It was decided that the software needed to be striped of all the OMP directives, leaving it bare. So, afterwards, it would be easier to make better analysis of the performance increases/decreases when changing code around.

Luckily, the OMP directives obey a very simple set of rules. They are all used with `!$OMP`. This makes very easy to remove them with the help of a tool. With that said, to remove all the OMP directives, the following UNIX command was used:
```bash
sed -i.bak 's|\!\$\s*OMP.*||gI' *.f* *.F*
```
Explanation of above command:
- `sed`, as described in the man [page](https://linux.die.net/man/1/sed):
>  sed - stream editor for filtering and transforming text
- `-i.bak` is a flag used to tell the tool to edit the file in place, creating an `.bak` file as backup;
- `'s|\!\$\s*OMP.*||gI'` is quite the RegEx to match things up;
  - This part works as this: `s|text_to_find|text_to_replace_with|g`. Which means `sed` is going to find everything that matches `text_to_find` and replace it with `text_to_replace_with`;
  - For more info about this regular expression, see [here](https://regex101.com/r/utEl19/1);
- `*.f* *.F*` is just the shell way of telling to apply the command to every file that have an `.f` or `.F` in it's name.


### Timing

Using the intrinsic function `CPU_TIME`, it is possible to get an approximated time of execution of the function. According to Intel's [reference](https://software.intel.com/en-us/node/679160):

> The time returned is summed over all active threads. The result is the sum (in units of seconds) of the current process's user time and the user and system time of all its child processes, if any.

With that said, it is a very reasonable parameter to test the increase/decrease of performance between different approaches.


#### How

- By placing 2 calls of `CPU_TIME`, one before, and one after the call of the EhrenfestForce procedure, in the [AO_adiabatic.f](../dynemol/AO_adiabatic.f) file, we can obtain a fairly good approximation of the execution time of the function.

- The difference between the return values of `CPU_TIME` was printed to the terminal. Along with everything else the program outputs.

- By changing the variable `n_t`, in [parameters.f](../dynemol/parameters.f), which hold the number of iterations of the main loop, to 100, we limit the runtime of the program to a more reasonable one. Minutes instead of hours.

- Piping the result of the program to a `res.txt` file and removing everything but the `CPU_TIME` values with a text editor.

- The following command was run to obtain the average:

```bash
echo "scale=5; `paste -sd+ res.txt | bc` / `wc -l < res.txt`" | bc
# paste and bc get the sum of all lines
# wl get the number of lines in the file
# bc divides both numbers
```

## Result

##### _as is_

Using the inputs provided in the [RET.tar](../dynemol/input/RET.tar) file, it was possible to get the following averages:
```bash
# first batch
7.44735
7.66855
7.56880
# second batch
7.39244
7.87155
7.36505
```
Note that these values were obtained from the code _as is_. Which means, there were no removals of any OMP directives.


##### OMP Directives

The following results are the times obtained after running the program without any OMP directives. All removed using the above explained command.



## Conclusion

As it is possible to note, there is some unexpected behavior of the times taken by the program. It was expected that the removal of the OMP directive from any of the files would result in loss of performance. Instead, removal from the Ehrenfest function resulted in an **increase** of performance.

The removal of the Pulay subroutines' OMP directives caused, as expected, an increase in the time taken to perform calculations. **BUT**, oddly enough, the removal of both, Pulay's and Ehrenfest's, OMP directives caused the execution to be performed faster than the one without Pulay's only.

So, there seems to be two options here:
- There is something extremely wrong with the tests;
- There is some kind of barrier with the OMP threads that prevents the program to run properly.


### Disclaimer

All tests described above were executed in the following machine:
- Intel(R) Xeon(R) CPU E5-2640 v4 @ 2.40GHz
- 128 Gb RAM
- NVIDIA Tesla K40c
