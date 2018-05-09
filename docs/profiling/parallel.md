# Parallel

Description of the profiling of the parallel version of the software.


## VTune

### Compiling

By parallel version, it is meant the version of the code __as is__.

The only compiler flag different from the original ones is the debug `-g` flag.
```bash
$ make debug  # adds -g flag to compiling process
```


### Profiling

The program was profiled using Intel's VTune. Using the command line utility.
```bash
$ amplxe-cl -collect hpc-performance -- ./a
```
It generated **1.3GB** of data.


### Reporting

```bash
Effective Physical Core Utilization: 6.3% (1.253 out of 20)
    Effective Logical Core Utilization: 3.2% (1.277 out of 40)
    Serial Time (outside parallel regions): 11.606s (70.0%)

        Top Serial Hotspots (outside parallel regions)
        Function                                                                              Module       Serial CPU Time
        ------------------------------------------------------------------------------------  -----------  ---------------
        [vmlinux]                                                                             vmlinux               3.082s
        _INTERNAL_25_______src_kmp_barrier_cpp_fa608613::__kmp_release_template<kmp_flag_64>  libiomp5.so           0.498s
        [Loop at line 411 in pulay_overlap]                                                   a                     0.414s
        [Loop@0x7512a1 in __intel_avx_rep_memset]                                             a                     0.316s
        [Loop at line 709 in solap]                                                           a                     0.248s
        [Others]                                                                              N/A                   6.648s
    Parallel Region Time: 4.964s (30.0%)
        Estimated Ideal Time: 4.441s (26.8%)
        OpenMP Potential Gain: 0.523s (3.2%)
...
# more info here
```
Here, the focus is on the CPU-bound portion of the summary.

First of all, `vmlinux` will be discussed later in this file.

Event though this is the parallel version of the software, most of it is ran serially. As it is possible to see in the `Serial time` values. ~70% of the runtime is executed serially. A valid conclusion is that, even though this version is already pretty parallelized, around 60 OpenMP directives scattered throughout the code, there is, still, lots of room for improvement.

When the program is executed with all the original parallelization on, some red flags are raised. After some research, it was discovered that the `__kmp_release_template` call is an OpenMP function used to release waiting threads, [link](https://github.com/llvm-mirror/openmp/blob/a838d8e95f40e21eabd704ec8e83a40405bc2c4c/runtime/src/kmp_wait_release.h#L435). The time spent here is even bigger than the time performing the math involved in this software. Leading to the conclusion that there are some deadlock/race conditions that take too much time to resolve.

The `__intel_avx_rep_memset` function is probably some call to set the memory of the Advanced Vector Extensions (AVX) normally included in modern CPU architectures. This function is probably well used in Intel's Math Kernel Library.

Oddly enough, the serial version has more effective physical, and logical, core utilization than the parallel one.

The rest of the calls are calls to the, well-known, `pulay_overlap` and `solap` procedures.


## Perf

Command:
```bash
$ perf stat -d ./a
```

```bash
 Performance counter stats for './a':

    1439984.391271      task-clock (msec)         #   37.476 CPUs utilized
         1,440,501      context-switches          #    0.001 M/sec
               703      cpu-migrations            #    0.000 K/sec
            28,235      page-faults               #    0.020 K/sec
 3,725,927,580,450      cycles                    #    2.587 GHz                      (50.01%)
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
 2,986,180,819,374      instructions              #    0.80  insns per cycle          (62.50%)
   853,669,924,625      branches                  #  592.833 M/sec                    (62.50%)
     1,136,692,527      branch-misses             #    0.13% of all branches          (62.50%)
 1,060,749,061,906      L1-dcache-loads           #  736.639 M/sec                    (62.50%)
     4,225,441,922      L1-dcache-load-misses     #    0.40% of all L1-dcache hits    (62.50%)
       354,827,936      LLC-loads                 #    0.246 M/sec                    (50.00%)
        43,666,588      LLC-load-misses           #   12.31% of all LL-cache hits     (50.00%)

      38.424270518 seconds time elapsed
```
