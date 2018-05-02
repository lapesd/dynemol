# Overlap

Description of tests to be made in the `Pulay_Overlap` procedure.


## How

Unfortunately, the same technique used in the `Ehrenfest` procedure, of using `CPU_TIME` calls to check the running time can't be used here. The problem is that, many times, the function does not execute completely or it returns immediately. Leaving the execution times quite random and inconclusive.

So there will be a new, and quite simple, approach. We will just compare the times outputted by the UNIX `time` tool and compare. We already know the expected outputs without OpenMP directives. The times without any OpenMP directives are already known:

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
Now, the only thing left to do is compare the above results with the new results, after code changes.
