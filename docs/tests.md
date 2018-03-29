# Tests

File created to describe some tests created to test the expected performance improvements when using some technique.

Computer:

- Model: Asus X205TA
- OS: Arch Linux
- Kernel: x86_64 Linux 4.15.12-1-ARCH
- CPU: Intel Atom Z3735F @ 4x 1.8326
- RAM: 1925MiB

Test code:

```f90
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

## Sequential

Compiled with `ifort test.f90 -warn all`

Executed with `time ./a.out 1000000`:
```bash
>$ time ./a.out 1000000
   813969.296637809

real	0m12.818s 	# This value stays consistent throughout tests
user	0m12.725s
sys	0m0.009s
```

-----

## OpenMP

Now, we test the concurrency of the system using the OpenMP directives.

Compiled with `ifort test.f90 -warn all -qopenmp`

Executed with `time ./a.out 1000000` (same as before):
```bash
>$ time ./a.out 1000000
   813969.296636646

real	0m3.857s 	# This value stays consistent throughout tests
user	0m14.964s
sys	0m0.020s
```

-----

## Conclusion

With OpenMP, we see a performance boost of a little more than 3 times. Therefore, we should, but are not obligated to, expect a performance boost of equal amount. Note that this performance boost is just in the above described machine. It can be of different ratios depending on the system.

It is fair to pay attention to the difference we got in the results. `...9.296637809` for the sequential program and `...9.296636646` for the concurrent one. For now, the priority is the performance gain of the software.
