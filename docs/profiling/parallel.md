# Parallel

Description of the profiling of the parallel version of the software.

## Compiling

By parallel version, it is meant the version of the code __as is__.

The only compiler flag different from the original ones is the debug `-g` flag.
```bash
$ make debug  # adds -g flag to compiling process
```


## Profiling

The program was profiled using Intel's VTune. Using the command line utility.
```bash
$ amplxe-cl -collect hpc-performance -- ./a
```
It generated **1.3GB** of data.


## Reporting

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
