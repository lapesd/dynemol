# Serial

Description of the profiling process for the serial version.


## Motivation

- Get base statistics to calculate improvements from.
- Know where to focus work.
  - Know which functions are the most time/processing power consuming ones.

### Compiling

Compiled with:
```bash
$ make serial 	# removes parallel flags and adds debug
```


## VTune

### Collecting

This step cant take a long time to complete. It took ~30 minutes to execute completely on a reasonably powerful machine. Go grab a coffee...

Ran with:
```bash
$ amplxe-cl -collect advanced-hotspots \ 		# specify which data to collect
  -data-limit=30000 \					# sets data size limit
  -verbose \
  -r ../profile/serial \				# where to save collected data
  -knob collection-detail=stack-and-callcount  -- \	# collects more info
  ./a 							# program to run
```

Brief explanation:

- `-collect advanced-hotspots` allows the more advanced configurations to be set to the profiling software. Basically a `-collect hotspots` on steroids.
- `-data-limit=30000` sets a higher limit to the size of collected data. The default, 500Mb, was too small. This size assure that **all** the execution was recorded.
- `-knob collection-detail=stack-and-callcount` adds this option to the collection process. According to Intel's [reference](https://software.intel.com/en-us/vtune-amplifier-help-knob):
> Extend the stack-and-callcount collection with an analysis of loop trip count statistically estimated using the hardware events. This value is used for advanced-hotspots only.

This configuration generated **13Gb** of data.

### Reporting


#### Hotspots

Report generated with:
```bash
$ amplxe-cl -report hotspots \
  -r ../profile/serial/ \
  -group-by function \
  -column 'CPU Time:Self,CPU Time:Effective Time:Self,Estimated Call Count:Self,Source File'
```

Output:

| function 			| time 		| file 													|
| ----------------- | --------: | ----------------------------------------------------- |
| `solap` 			| 8.215s 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `solap` 			| 6.525s 	| [multip_routines.f](../../dynemol/multip_routines.f) 	|
| `pulay_overlap` 	| 5.770s 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `solap` 			| 2.922s 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `multipoles2c` 	| 2.438s 	| [multip_routines.f](../../dynemol/multip_routines.f) 	|


##### Conclusions:

All the times displayed above are [CPU Effective](https://software.intel.com/en-us/vtune-amplifier-help-effective-time) times.

- Need to focus on the above functions for better performance.

-----

#### Hardware events

Report generated with:
```bash
$ amplxe-cl -report hw-events \
  -r ../profile/serial/ \
  -column 'Hardware Event Count:CPU_CLK_UNHALTED.THREAD:Self,Hardware Event Count:CALL_COUNT:Self,Context Switch Time:Self,Source File'
```

Output:

| function 			| cycles 			| file 													|
| ----------------- | ----------------: | ----------------------------------------------------- |
| `solap` 			| 21.537.581.687 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `solap` 			| 16.314.692.994 	| [multip_routines.f](../../dynemol/multip_routines.f) 	|
| `pulay_overlap` 	| 14.831.939.757 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `solap` 			| 7.514.002.370 	| [overlap_D.f](../../dynemol/overlap_D.f) 				|
| `multipoles2c` 	| 6.790.169.538 	| [multip_routines.f](../../dynemol/multip_routines.f) 	|


##### Conclusions

- This result just confirms the one in the previous item.

-----

#### Callstacks

Report generated with:
```bash
$ amplxe-cl -report callstacks \
  -r ../profile/serial/ \
  -group-by function \
  -column 'CPI Rate'
```

Output:

| function 			| CPI rate |
| ----------------- | -------: |
| `solap` 			| 2.207	   |
| `pulay_overlap` 	| 1.611	   |
| `solap` 			| 1.324	   |
| `solap` 			| 1.141	   |
| `multipoles2c` 	| 1.067	   |


##### Conclusions

- `-report callstacks` only allows one item in the `column` argument. So, it is not too clear which function is which here.
- Functions and its CPI (cycles per instruction):
- The lower the CPI rate value, lower the cache hit performance of the function (usually).


## Perf

Command:
```bash
$ perf stat -d ./a
```

Output:
```
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
