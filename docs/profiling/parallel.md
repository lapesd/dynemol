# Parallel

Description of the profiling of the parallel version of the software.


## Motivation

- Get base statistics about the concurrent version of the software.
- Know if there are improvements to be done in the OpenMP directives placement and/or configuration.

### Compiling

Compiled with:
```bash
$ make debug  # adds -g flag to compiling process
```


## VTune

### Collecting (concurrency)

Run with:
```bash
$ amplxe-cl -collect concurrency \ 	# specify which data to collect
  -data-limit=30000 \			# sets data size limit
  -verbose \
  -r ../profile/parallel \		# where to save collected data
  -knob analyze-openmp=true -- \	# collects more info
  ./a 					# program to run
```
It generated **168Mb** of data.


### Collecting (hpc-performance)

Run with:
```bash
$ amplxe-cl -collect hpc-performance \ 	# specify which data to collect
  -data-limit=30000 \			# sets data size limit
  -verbose \
  -r ../profile/hpc --\			# where to save collected data
  ./a 					# program to run
```
It generated **2.1Gb** of data.


### Reporting (concurrency)

Report generated with:
```bash
$ amplxe-cl -report summary -r ../profile/parallel/
```

Output:
```
Summary
-------
Average Concurrency:      37.971
Elapsed Time:             66.753
Paused Time:              0.0
CPU Time:                 2468.526
Wait Time:                84.435
Average CPU Utilization:  1.706
```

Second report generated with:
```bash
# amplxe-cl -report hotspots \
  -r ../profile/parallel/ \
  -group-by function \
  -column 'CPU Time:Self,CPU Time:Effective Time:Self,CPU Time:Spin Time:Self'
```

Output:

| function 				| CPU time 	| CPU time effective 	| CPU time spin |
| :-------------------- | --------: | --------------------:	| ------------: |
| `__kmp_fork_barrier` 	| 2254.982s | 0s 					| 2254.431s		|
| `__kmp_barrier` 		| 32.988s 	| 0s 					| 32.647s 		|
| `__kmp_join_barrier` 	| 27.303s 	| 0s 					| 26.947s 		|
| `__kmp_join_call` 	| 23.454s 	| 0s 					| 21.768s 		|
| `__kmp_fork_call` 	| 23.453s 	| 0s 					| 0.056s 		|
| `solap` 				| 23.445s 	| 23.445s 				| 0s 			|
| `[MKL LAPACK]@dsytd3`	| 11.277s 	| 1.151s 				| 9.761s 		|
| `solap` 				| 10.217s 	| 10.217s 				| 0s 			|
| `solap` 				| 9.938s 	| 9.938s 				| 0s 			|
| `pulay_overlap` 		| 5.741s 	| 5.741s 				| 0s 			|


#### Conclusion

- Most of the running time of the software is wasted in barriers.
  - There are **lots** of possible improvements to be done here.
- Low CPU utilization.
  - Also, lots of possible improvements.

-----

### Reporting (hpc-performance)

Report generated with:
```bash
$ amplxe-cl -report summary \
  -r ../profile/hpc/ \
  -report-knob show-issues=false	# just tells it to not print some helpful messages
```

Output (main parts):

```
Effective Physical Core Utilization: 11.7% (2.345 out of 20)
    Effective Logical Core Utilization: 11.6% (4.651 out of 40)
    Serial Time (outside parallel regions): 14.605s (36.2%)

        Top Serial Hotspots (outside parallel regions)
        Function                             Module   Serial CPU Time
        -----------------------------------  -------  ---------------
        [Loop at line 411 in pulay_overlap]  a                 3.347s
        [vmlinux]                            vmlinux           1.139s
        [Loop at line 337 in pulay_overlap]  a                 1.033s
        [Loop at line 411 in pulay_overlap]  a                 0.782s
        [Loop at line 239 in basis_builder]  a                 0.646s
        [Others]                             N/A               7.260s
    Parallel Region Time: 25.793s (63.8%)
        Estimated Ideal Time: 2.685s (6.6%)
        OpenMP Potential Gain: 23.108s (57.2%)
```

Second report generated with:
```bash
$ amplxe-cl -report hotspots \
  -r ../profile/hpc \
  -group-by function \
  -column 'CPU Time:Self,CPU Time:Effective Time:Self,Memory Bound:Self'
```

Output:

| function | serial CPU Time | CPU Time | CPU Time:Effective | Memory Bound(%) |
| :-------------------------------------------- | -----: | -------: | --------: | ----: |
| [Loop at line 411 in pulay_overlap] 			| 3.347s | 3.347s 	| 3.347s 	| 33.6% |
| [vmlinux] 									| 1.139s | 106.245s | 106.245s 	| 6.5%  |
| [Loop at line 337 in pulay_overlap] 			| 1.033s | 1.033s 	| 1.033s 	| 26.6% |
| [Loop at line 411 in pulay_overlap] 			| 0.782s | 0.856s 	| 0.856s 	| 6.0%	|
| [Loop at line 239 in basis_builder] 			| 0.646s | 0.646s 	| 0.646s 	| 0.0%	|
| for_adjustl 									| 0.579s | 0.579s 	| 0.579s 	| 0.0%	|
| [Loop at line 181 in basis_opt_parameters] 	| 0.504s | 0.504s 	| 0.504s 	| 0.0%	|


#### Conclusion

- Effective physical, and logical, core utilization is low.
  - Huge space for improvements.
- Serial time is still big, could possibly be reduced with `workshare` directive.
- Need to focus on `pulay_overlap`.
- For the future, check for memory bound operations.


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
