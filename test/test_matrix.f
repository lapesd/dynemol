program main

! File created to test the array slices syntax in fortran.
!
! See link for more info.
! https://docs.oracle.com/cd/E19205-01/819-5257/blagu/index.html
!

integer :: arr(5,5)
integer :: i, j


! It should print the lower part of the matrix, below the main diagonal:

! Add numbers 1 to 25 to matrix
do i=1, 5
    do j=1, 5
        arr(i,j) = 5 * (i - 1) + j
    end do
end do

do i=1, 5
    ! Print line
    print*, arr(i:,i) ! upper triangle
    ! print*, arr(i,:i) ! lower triangle
end do

end program main
