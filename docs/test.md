# Tests

This file contains some basic context of the tests that are in the [tests](./tests) folder.


## Why?

First of all, there need to be a basis parameter to check for performance increases/decreases. This basis parameter, in this project, is the software received, _as is_, with all the OMP directives removed.

- By _as is_, it is meant with little modifications. The only ones made where the removal of the `pure` keyword and commenting an import. Both of them in [DP_main.f](../dynemol/DP_main.f). After further discussion with the teacher, the errors it gave were probably because of compilers' versions.


## OMP Removal

The first tests were performed with the software _as is_, but it was not possible to conclude much from it. When checking the runtime of threads, it was noted that many threads were created, but not by the procedures that were being analyzed. This left space for confusion.

It was decided that the software needed to be stripped of all the OMP directives, leaving it bare. So, afterwards, it would be easier to make better analysis of the performance increases/decreases when changing code around.

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


## Timing

Using the intrinsic function `CPU_TIME`, it is possible to get an approximated time of execution of the function. According to Intel's [reference](https://software.intel.com/en-us/node/679160):

> The time returned is summed over all active threads. The result is the sum (in units of seconds) of the current process's user time and the user and system time of all its child processes, if any.

With that said, it is a very reasonable parameter to test the increase/decrease of performance between different approaches.

### PS

By changing the variable `n_t`, in [parameters.f](../dynemol/parameters.f), which hold the number of iterations of the main loop, to 100, we limit the runtime of the program to a more reasonable one. Minutes instead of hours.
