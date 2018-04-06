# Tests

Description of some tests created to check for the expected performance improvements when using some technique.


## Parameters

First of all, there need to be a basis parameter to check for performance increases/decreases. This basis parameter, in this project, is the software received, _as is_.

- By _as is_, it is meant with little modifications. The only ones made where the removal of the `pure` keyword and commenting an import. Both of them in [DP_main.f](../dynemol/DP_main.f).


## Ehrenfest Force

Using the intrinsic function `CPU_TIME`, it is possible to get an approximated time of execution of the function.

According to Intel's [reference](https://software.intel.com/en-us/node/679160):

> The time returned is summed over all active threads. The result is the sum (in units of seconds) of the current process's user time and the user and system time of all its child processes, if any.

With that said, it is a very reasonable parameter to test the increase/decrease of performance between different approaches.


### Results

The following results were obtained by placing 2 calls of CPU_TIME, one before, and one after the call of the EhrenfestForce procedure, in the [AO_adiabatic.f](../dynemol/AO_adiabatic.f) file.

The difference between the return values of CPU_TIME was printed to the terminal.

By changing the variable `n_t`, in [parameters.f](../dynemol/parameters.f), which hold the number of iterations of the loop, to 100, we could limit the runtime of the program to a more reasonable one.

Piping the result of the program to a `res.txt` file and removing **everything** but the CPU_TIME values, the following command was run to obtain the average:

```bash
echo "scale=5; `paste -sd+ res.txt | bc` / `wc -l < res.txt`" | bc
```
Quick run of the command:
- `paste -sd+ res.txt | bc` gets the sum of all numbers, one per line, in the file;
- `wc -l < res.txt` gets the total number of lines in the file;
- `"scale=5; first / second" | bc` just pipes the results from the above explained scripts to `bc` and divides to a real number.

#### RET.tar

Using the inputs provided in the [RET.tar](../dynemol/input/RET.tar) file, it was possible to get the following average `CPU_TIME` of the function:

```
5.99111
```
