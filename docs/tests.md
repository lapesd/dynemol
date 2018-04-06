# Tests

Description of some tests created to check for the expected performance improvements when using some technique.


## Parameters

First of all, there need to be a basis parameter to check for performance increases/decreases. This basis parameter, in this project, is the software received, _as is_.

> By _as is_, it is meant with little, to no, modifications. The only ones made where the removal of the `pure` keyword and commenting an import. Both of them in [DP_main.f](../dynemol/DP_main.f).

### Pre/Post processing

Using the custom build tool [test.sh](../scripts/test.sh), we performed tests to check how much time every iteration of the program would take. For this, the variable `n_t`, in [parameters.f](../dynemol/parameters.f), was modified to 0. This was done to check how much time the software takes to do all the pre/post processing.

Using the inputs provided in [RET.tar](../dynemol/inputs/RET.tar).

```bash
dynemol >$ bash ../scripts/test.sh 100 ./a
Times for each run:
     1	1.151
     2	1.186
     3	1.148
     ...
   100	1.002

Medium of runs:
1.031
```

With the above test, we see that the pre/post processing takes about 1.03 seconds. As this is a program that runs for hours/days, there is no need to make changes to the parts related to it.


### Iterations

As in [Pre/Post processing](#prepost-processing), we will edit the [parameters.f](../dynemol/parameters.f) file. Again, the `n_t` variable. But, this time, it will be changed to 1. With it, will be possible to see how much time each iteration takes.

Again, using the inputs from [RET.tar](../dynemol/inputs/RET.tar).

```bash
dynemol >$ bash ../scripts/test.sh 100 ./a
Times for each run:
     1	1.049
     2	1.070
     3	0.960
     ...
   100	0.991

Medium of runs:
1.012
```

# TODO
Oddly enough, the average with 1 iteration was faster than the average with 0 iterations...

Changing `n_t` to 2, however...

```bash
dynemol >$ bash ../scripts/test.sh 100 ./a
Times for each run:
     1	1.606
     2	1.601
     3	1.369
     ...
   100	1.406

Medium of runs:
1.415
```

Here we see a bigger change in processing time. Further testing, for 3, 4, 5 and 10 iterations got the following averages respectively:
- 1.579
- 1.589
- 1.593
- 3.003
