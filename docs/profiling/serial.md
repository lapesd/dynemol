# Serial

Description of the profiling of the serial version of the software.


## VTune

### Compiling

By serial version, it is meant the version of the code without any of the OpenMP directives. All removed with:
```bash
$ sed -i.bak 's|\!\$\s*OMP.*||gI' *.f* *.F*
```
And compiled without any of the parallel flags. `-qopenmp` and `-parallel`. And with the debug flag `-g` on, for profiling reasons.
```bash
$ make serial  # removes parallel flags and adds debug
```


### Profiling

The program was profiled using Intel's VTune. Using the command line utility.
```bash
$ amplxe-cl -collect hpc-performance -- ./a
```
It generated **997MB** of data.


### Reporting

Again, using the command line utility:
```bash
$ amplxe-cl -report summary -report-knob show-issues=false
```

The (important) output was:
```bash
Effective Physical Core Utilization: 11.9% (2.388 out of 20)
    Effective Logical Core Utilization: 6.0% (2.406 out of 40)
    Serial Time (outside parallel regions): 32.869s (98.3%)

        Top Serial Hotspots (outside parallel regions)
        Function                             Module  Serial CPU Time
        -----------------------------------  ------  ---------------
        solap                                a                3.747s
        [Loop at line 411 in pulay_overlap]  a                2.851s
        [Loop at line 709 in solap]          a                1.512s
        solap                                a                1.500s
        [Loop at line 736 in solap]          a                1.316s
        [Others]                             N/A             21.163s
    Parallel Region Time: 0.580s (1.7%)
        Estimated Ideal Time: 0.356s (1.1%)
        OpenMP Potential Gain: 0.224s (0.7%)
...
# more info down here
```
Here, the focus is on the CPU-bound portion of the summary.

There is lots of important information here. First of all, as this version is the serial one, the physical core utilization and the following ones are very low. As expected. The use of more than one, not expected, core is because of `blas` and `lapack` math libraries included in Intel's Parallel Studio. It spawn threads to parallelize some matrix operations and they are used in this program. At last, the serial time was almost all of the running time (~98%), as expected.

The most important part of this summary is the hotspots analysis table. It shows how much time the processor spent on each function. As already noted in the procedures analysis, see [overlap](../procedures/overlap.md) for more info, the most time consuming procedure is the pulay_overlap one. solap is actually called from within pulay_overlap.


## Perf

Command:
```bash
$ perf stat -d ./a
```

```bash
 Performance counter stats for './a':

     448195.190178      task-clock (msec)         #    7.974 CPUs utilized
           270,407      context-switches          #    0.603 K/sec
               261      cpu-migrations            #    0.001 K/sec
            25,391      page-faults               #    0.057 K/sec
 1,358,407,730,487      cycles                    #    3.031 GHz                      (50.04%)
   <not supported>      stalled-cycles-frontend
   <not supported>      stalled-cycles-backend
 1,401,474,701,367      instructions              #    1.03  insns per cycle          (62.53%)
   371,689,145,941      branches                  #  829.302 M/sec                    (62.51%)
       494,990,952      branch-misses             #    0.13% of all branches          (62.49%)
   483,984,914,427      L1-dcache-loads           # 1079.853 M/sec                    (62.48%)
     4,586,089,502      L1-dcache-load-misses     #    0.95% of all L1-dcache hits    (62.48%)
     1,230,345,503      LLC-loads                 #    2.745 M/sec                    (50.00%)
       356,635,377      LLC-load-misses           #   28.99% of all LL-cache hits     (50.02%)

      56.204127957 seconds time elapsed
```
---

All of this was to have the basis performance to which compare the future obtained results of the parallelizing approaches.
