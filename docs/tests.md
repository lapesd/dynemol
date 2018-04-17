# Tests

Description of some tests created to check for the expected performance improvements when using some technique.


## Why?

First of all, there need to be a basis parameter to check for performance increases/decreases. This basis parameter, in this project, is the software received, _as is_.

- By _as is_, it is meant with little modifications. The only ones made where the removal of the `pure` keyword and commenting an import. Both of them in [DP_main.f](../dynemol/DP_main.f).

Using the intrinsic function `CPU_TIME`, it is possible to get an approximated time of execution of the function. According to Intel's [reference](https://software.intel.com/en-us/node/679160):

> The time returned is summed over all active threads. The result is the sum (in units of seconds) of the current process's user time and the user and system time of all its child processes, if any.

With that said, it is a very reasonable parameter to test the increase/decrease of performance between different approaches.


### How

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

#### RET.tar

Using the inputs provided in the [RET.tar](../dynemol/input/RET.tar) file, it was possible to get the following averages:
```
7.44735
7.66855
7.56880
```

These numbers will be used as a basis for the tests using the `RET.tar` input.

##### OMP Directives

The following tests show the performance impacts in executing the code without some OMP directives:

Removed from Ehrenfest function in [Ehrenfest.f](../dynemol/Ehrenfest.f):
```
6.90436
6.88848
6.98351
```

Removed from Pulay overlap subroutine in [overlap_D.f](../dynemol/overlap_D.f):
```
12.90012
13.01070
12.97515
```

Removed from both, Pulay overlap subroutine and Ehrenfest function:
```
7.97534
8.04893
8.00157
```

## Conclusion

As it is possible to note, there is some unexpected behavior of the times taken by the program. It was expected that the removal of the OMP directive from the any of the files would result in loss of performance. Instead, removal from the Ehrenfest function resulted in an **increase** of performance.
