
# Ehrenfest

File where the Ehrenfest function ([file](../dynemol/Ehrenfest.f)) is described more thoroughly.


## Parameters


### system

```f90
type(structure), intent(inout) :: system
```
Describe the universe of the model being simulated. It's parameters vary between constants of this said universe to big allocatable arrays to be used to store many of its values.

It is fair to note that it only stores default data types. Such as `real`, `complex` etc.


### basis

```f90
type(STO_basis), intent(in) :: basis(:)
```
Describes many values to be used in the calculations. It is a simpler custom type than the `structure` one. It does not have allocatable arrays and only seems to store a finite set of variables. All of them, default data types.


### site

```f90
integer, intent(in) :: site
```
Seems to be the index of the atom which we want to calculate the value of.


## Return


### Force

```f90
real*8 :: Force(3)
```


## Code

In this section there will be the _dissecting_ of the Ehrenfest function, line-by-line. The function is located [here](../dynemol/Ehrenfest.f).


### Line-by-line


```f90
function Ehrenfest( system, basis, site ) result(Force)
```
First of all, we see that this function takes 3 parameters. All of them described above already and return an array of three real numbers.


```f90
use Semi_empirical_parms , only: atom
```
`atom` is an array of 300 items, `type(EHT)` which is declared in [EHT_input.f](../dynemol/EHT_input.f).

This type, `EHT`, holds some data related to the geometric space of some object. It is only used later to get the `DOS` parameter from one of its items.


```f90
implicit none

type(structure)  , intent(inout) :: system
type(STO_basis)  , intent(in)    :: basis(:)
integer          , intent(in)    :: site

integer :: i , j , xyz , size_basis , jL , L , indx
integer :: k , ik , DOS_atom_k , BasisPointer_k

integer , allocatable :: pairs(:)
real*8  , allocatable :: S_fwd(:,:) , S_bck(:,:)
real*8                :: Force(3) , tmp_coord(3) , delta_b(3)
```
Disable implicit declarations, as always, and declare everything.


```f90
verbose    = .false.
```
Variable no used inside this function.


```f90
size_basis = size(basis)
```
Gets the size of the `basis` parameter. After some unfruitful research, I made some tests and discovered that this function is, in fact O(1). Or it seems so.


```f90
grad_S     = D_zero
```
`grad_S` is an allocatable, 2D, array of real numbers. And `D_zero` is a constant of value ZERO (yes...).

After more investigation, and testing, I have discovered it is possible to _assign_ a value to array. This will make all values become that value. Example: `arr = 5 => [5, 5, 5, ...]`. So, the line of the above code makes all values of `grad_S` become zero.


```f90
k = site
DOS_atom_k     =  atom( system% AtNo(k) )% DOS
BasisPointer_k =  system% BasisPointer(k)
```
The second line gets the `DOS` attribute, an integer, from the _kth_ atom. This values is only used as a limit setter for `do` loop.

The third line gets the `BasisPointer`, also an integer, of the _kth_ element in the system. It is only used as index for some arrays later on.


```f90
allocate( pairs , source = pack([( L , L=1,system% atoms )] , mask(:,K)) )
```
There are lots of things going on this line. In parts:
- `pairs` is simply an allocatable array of integers defined in the function;
- `source` parameter is an expression (some value or operation; Example: `1 + 1`, `10 * 2` etc.) used to describe the size or format of the array being allocated. 2D with 5 items in one dimension and 10 in other, 3D etc.
	- `pack` function, according to Intel's [reference](https://software.intel.com/en-us/node/679627), is used to get elements that match the `mask` parameter and returns them.
		- `[( L , L=1,system% atoms )]` is, in essence, the same as Python's list comprehensions. It could be _translated_ to Python's `[l for l in range(system.atoms)]`. It will result in a list of values varying from 1 to the `system % atoms` number;
		- `mask` is a 2D logical allocatable array. It is used to select which atoms match some predetermined condition.

After all of that, this line is allocating the `pairs` array with the value resulted of the `pack` function. In the end, pairs will hold a matrix of integers that matches the conditions of the `mask` passed in the `pack`.

The conditions of the `mask` are defined during runtime in the `Preprocess` subroutine, located in [Ehrenfest.h](../dynemol/Ehrenfest.f). They obey some user inputs on the files passed by the teacher. It is safe to say that these flags are configurations of the simulation.


```f90
tmp_coord = system% coord(k,:)
```
Select temporary coordinate, an array of 3 real values.


```f90
do xyz = 1 , 3
...
...
...
end do
```
Do it 3 times.


```f90
delta_b = delta * merge(D_one , D_zero , xyz_key == xyz )
```
Very interesting line. The `merge` function will return an array of 1s and 0s matching the result of the expression `xyz_key == xyz`. This expression, will return a mask depending on the value of `xyz`. `xyz_key` is a constant array of reals `[1, 2, 3]`.

For example:
- `[1, 2, 3] == 1` will result in a mask `[T, F, F]`;
- The `merge` will check the mask and apply the first argument for the true items and the second for the false ones. So the function will return an array like `[1, 0, 0]`.

`delta` is another constant. It's a value very small, `1d-8`, to be precise.

In the end, `delta_b` will hold the result of multiplying an vector of 1s and 0s to by `delta`.


```f90
system% coord (k,:) = tmp_coord + delta_b
```
Store the new value of the _kth_ coordinate. Basically, sum the value of `delta` to one single value of the coordinate.


```f90
system% coord (k,:) = tmp_coord + delta_b
CALL Overlap_Matrix( system , basis , S_fwd , purpose = "Pulay" , site = K )

system% coord (k,:) = tmp_coord - delta_b
CALL Overlap_Matrix( system , basis , S_bck , purpose = "Pulay" , site = K )
```
Not getting too much into the subroutines itself, it will be done in another document. But, after a quick look, is easy to note that a big bulk of the processing is performed inside these procedures. Matrix multiplication and other iterations.


```f90
forall( j=1:DOS_Atom_K ) grad_S(:,j) = ( S_fwd( : , BasisPointer_K+j ) - S_bck( : , BasisPointer_K+j ) ) / (TWO*delta)
```
Saves the newly calculated values to the `grad_S` matrix.


```f90
F_vec = D_zero
```
Zero everything.


```f90
do indx = 1 , size(pairs)
    L = pairs(indx)
    do jL = 1 , DOS(L)
        j = BasisPointer(L) + jL
        do iK = 1 , DOS_atom_K
            i = BasisPointer_K + iK
            F_vec(L) = F_vec(L) -  grad_S(j,iK) * Kernel(i,j)
		end do 	! iK
    end do  	! jL
end do  		! indx
```
This section is, basically, some sort of multiplication of matrices. But, instead of using simple coordinates from the loops, it uses some set of coordinates defined by the `BasysPointer` of the `system` parameter.

The original code uses OpenMP for the outer loop. It does not seem, at first glance, a very good use of it. It has room for improvements.


```f90
do L = K+1, system% atoms
	F_mtx(K,L,xyz) =   F_vec(L)
	F_mtx(L,K,xyz) = - F_mtx(K,L,xyz)
end do
```
This part is kinda tricky. It takes the values of `F_vec` and stores it, and it's opposite values in the same 3D matrix. It stores the positive values in the line, and the negative in the columns.


```f90
F_mtx(K,K,xyz) = D_zero
```
Sets the current place in the diagonal to 0.


```f90
Force(xyz) = two * sum( F_mtx(K,:,xyz) )
```
Update return value.
