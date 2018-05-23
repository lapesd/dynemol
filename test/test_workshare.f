program main

integer :: arr(100, 10000)
integer :: i, j
integer :: s
character(len=1) :: arg

! Test created to see the possible differences between the use of the WORKSHARE
! directive and do loops.
!
! CONCLUSION:
! It depends on what operation is being performed and in what size array/matrix.
! For example:
! Option 0 and 1. 0 is not parallelized, but it runs faster than option 1, which
! is.
! But, option 2 and 3. 2 is not parallelized and it runs 3 times slower than
! option 3.
!
! OUTPUT:
!  Option 2
!
! real    0m10.204s
! user    0m10.109s
! sys 0m0.024s
!
!  Option 3
!
! real    0m3.255s
! user    0m12.339s
! sys 0m0.125s



! Size
s = 100

call getarg(1, arg)
! Which test to do
print*, 'Option ', arg

! Line by line assignment
if (arg ==  '0') then
    do j=1, 1000
        forall(i=1:s) arr(i,:) = i
    end do
endif

! Line by line assignment parallel
if (arg == '1') then
    do j=1, 1000
        !$OMP parallel workshare
        forall(i=1:s) arr(i,:) = i
        !$OMP end parallel workshare
    end do
endif

! Whole array assignment
if (arg == '2') then
    do j=1, 1000
        arr = j
    end do
endif

! Whole array assignment parallel
if (arg == '3') then
    do j=1, 1000
        !$OMP parallel workshare
        arr = j
        !$OMP end parallel workshare
    end do
endif

if (arg == '4') then
    ! this here will have no effect. Because we are changing the whole array. So,
    ! every thread will have to wait for the prior operation to end before it
    ! can do anything
    !$OMP parallel workshare
    forall(j=1:1000)
        arr = j
    end forall
    !$OMP end parallel workshare
endif

end program main
