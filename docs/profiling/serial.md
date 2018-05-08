# Serial

Description of the profiling of the serial version of the software.

## Compiling

By serial version, it is meant the version of the code without any of the OpenMP directives. All removed with:
```bash
$ sed -i.bak 's|\!\$\s*OMP.*||gI' *.f* *.F*
```
And compiled without any of the parallel flags. `-qopenmp` and `-parallel`. And with the debug flag `-g` on, for profiling reasons.
```bash
$ make serial  # removes parallel flags and adds debug
```


## Profiling

The program was profiled using Intel's VTune. Using the command line utility.
```bash
$ amplxe-cl -collect hpc-performance -- ./a
```
It generated **997MB** of data.


## Reporting

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

---

All of this was to have the basis performance to which compare the future obtained results of the parallelizing approaches.
