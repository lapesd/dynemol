# Profiling

Description of the software profiling process.


## Machine

All the profiling was done in the following computer via SSH:
- Intel(R) Xeon(R) CPU E5-2640 v4 @ 2.40GHz
- 128 Gb RAM
- NVIDIA Tesla K40c


## Intel VTune Amplifier

Using Intel's software it was capable of doing a very in-depth profiling of the application. The real interesting part, for this project, is the OpenMP region analysis. Intel's VTune does a very good job in profiling it.

The command used for it was, from Intel's [website](https://software.intel.com/en-us/vtune-amplifier-help-openmp-analysis-from-the-command-line):
```bash
$ amplxe-cl -collect hpc-performance -- ./a
```
`hpc-performance` has the OpenMP analysis flags on/true by default, so it is easier to use it.

By default, VTune creates an folder with the names `rxxxyyy` in the current directory to store all the information it gathers during runtime. `xxx` is usually a number representing which profiling it refers to. Starting at 0. The `yyy` says what analysis type was used. In the case above, the output folder was `r000hpc`.

In this case, a new folder was created by hand, beforehand, to store the profiling.

- PS: It takes a little bit to run the profiling. If it is a very complex software it may take very long (>1hr) to complete.

After executing the analysis, it is possible to visualize reports of it. The following command was used (better explained [here](https://software.intel.com/en-us/vtune-amplifier-help-openmp-analysis-from-the-command-line)):
```bash
$ amplxe-cl -report summary -r r000hpc -report-knob show-issues=false
```
The output of it is a summary of the info. It shows the following:
- Effective Physical Core Utilization
- Effective Logical Core Utilization
- Serial Time (outside parallel regions)
- Parallel Region Time
- Estimated Ideal Time
- OpenMP Potential Gain
- ...

See [here](https://software.intel.com/en-us/vtune-amplifier-help-generating-command-line-reports) for more info on the reports.
