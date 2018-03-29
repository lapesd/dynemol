# Tests

This file was created to store some tests created to check for the expected performance gain in the development computer.


Computer:

- Model: Asus X205TA
- OS: Arch Linux
- Kernel: x86_64 Linux 4.15.12-1-ARCH
- CPU: Intel Atom Z3735F @ 4x 1.8326
- RAM: 1925MiB

Test code:

```fortan
program tests
use omp_lib

implicit none

! calc variables
integer :: i, j
real(kind=8) :: res

! input variables
character(len=10) :: arg
integer :: argc, total

argc = iarg()
call getarg(argc, arg)
read(arg, '(I)') total

res = 0

!$omp parallel

!$omp do schedule(static) reduction(+:res)
do i = 1, total
        do j = 1, 1000
                res = res + sin(real(j))
        end do
end do

!$omp end parallel

print *, res

end program tests
```

Compiled with `ifort test.f90 -warn all`

Executed with `time ./a.out 1000000`:
```
   813969.296637809

real	0m12.818s
user	0m12.725s
sys	0m0.009s
```

The value of 12 seconds stays consistent throughout tests.

Now, we test the concurrency of the system using the OpenMP directives.

Compile with `ifort test.f90 -warn all -qopenmp`

Executed with `ifort fizz.f90 -warn all -qopenmp` (same as before):
```
   813969.296636646

real	0m3.857s
user	0m14.964s
sys	0m0.020s
```

The value of ~3.8 seconds stays consistent throughout tests.

We see a performance boost of a little more than 3 times. Therefore, we should, but are not obligated to, expect a performance boost of around 3 times the sequential execution in this machine.
