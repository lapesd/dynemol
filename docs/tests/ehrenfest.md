# Ehrenfest

Description of some tests created to check Ehrenfest running time/cost.


## How

- By placing 2 calls of `CPU_TIME`, one before, and one after the call of the `EhrenfestForce` procedure, in the [AO_adiabatic.f](../../dynemol/AO_adiabatic.f) file, we can obtain a fairly good approximation of the execution time of the function.

- The difference between the return values of `CPU_TIME` was printed to the terminal. Along with everything else the program outputs.

- Piping the result of the program to a `res.txt`, for example, file and removing everything but the `CPU_TIME` values with a text editor.

- The following command was run to obtain the average:

```bash
echo "scale=5; `paste -sd+ res.txt | bc` / `wc -l < res.txt`" | bc
# paste and bc get the sum of all lines
# wl get the number of lines in the file
# bc divides both numbers
```

## Result

### _as is_

From commit ab9044d2af9b16946a7b443e9dcf536174df35eb

Note that these values were obtained from the code _as is_. Which means, there were **no** removals of any OMP directives.

Using the inputs provided in the [RET.tar](../dynemol/input/RET.tar) file, it was possible to get the following averages:
```bash
# 6 runs
# 100 steps each
5.87608
6.10617
5.95054
5.99603
6.07971
6.17971
```

And the time it took to compute each one (using `time` tool):
```bash
real	0m38.458s
user	22m39.348s
sys	1m20.436s

real	0m39.035s
user	23m0.848s
sys	1m22.076s

real	0m38.640s
user	23m1.328s
sys	1m21.940s

real	0m39.034s
user	22m56.748s
sys	1m20.448s

real	0m39.199s
user	23m12.472s
sys	1m22.216s

real	0m39.950s
user	23m10.492s
sys	1m22.388s

```


### OMP Removal

The following results are the times obtained after running the program without any OMP directives.

```bash
# 6 runs
# 100 cycles each
1.39507
1.40428
1.40282
1.39167
1.41729
1.43066
```
The seemingly smaller time is due the high number of threads that are used in the OMP version. It is possible to see it more clearly by looking at the total time it takes to compute everything (info below). Even with the smaller average time the thread took to calculate the Ehrenfest procedure, the total time of calculation got bigger.

Total computing times:
```bash
real	0m55.193s
user	7m12.520s
sys	0m9.340s

real	0m56.465s
user	7m24.328s
sys	0m9.524s

real	0m56.831s
user	7m27.556s
sys	0m9.136s

real	0m54.398s
user	7m7.312s
sys	0m8.944s

real	0m57.520s
user	7m31.588s
sys	0m9.152s

real	0m57.247s
user	7m29.744s
sys	0m9.300s
```
It takes ~56 seconds to run the program, 100 cycles, without any OpenMP directives. This is close to a third of loss in performance. But it will make it a little bit easier to see how much of an improvement/worsening has been done to the software.


## Conclusion

We should get a ~30% performance boost to accept changes. Of course, now there is none of the other OpenMP directives. Which may impact, a little, in the performance metrics. But, if it is possible to get a ~30% boost by only working in the Ehrenfest procedure, it will be worth it.


### Disclaimer

All tests described above were executed in the following machine:
- Intel(R) Xeon(R) CPU E5-2640 v4 @ 2.40GHz
- 128 Gb RAM
- NVIDIA Tesla K40c
