
# Ehrenfest

File where the Ehrenfest function ([file](../dynemol/Ehrenfest.f)) is described more thoroughly.


## Parameters


### system

`type(structure), intent(inout) :: system`

Describe the universe of the model being simulated. It's parameters vary between constants of this said universe to big allocatable arrays to be used to store many of its values.

It is fair to note that it only stores default data types. Such as `real`, `complex` etc.


### basis

`type(STO_basis), intent(in) :: basis(:)`

Describes many values to be used in the calculations. It is a simpler custom type than the `structure` one. It does not have allocatable arrays and only seems to store a finite set of variables. All of them, default data types.


### site

`integer, intent(in) :: site`

Seems to be the index of the atom which we want to calculate the value of.


## Return


### Force

`real*8 :: Force(3)`


## Code

In this section there will be the _dissecting_ of the Ehrenfest function, line-by-line. The function is located [here](../dynemol/Ehrenfest.f).


### Line-by-line


```f90
function Ehrenfest( system, basis, site ) result(Force)
```
First of all, we see that this function takes 3 parameters. All of them described above already and return an array of three real numbers. Probably, the forces in each axis of 3D space, XYZ.


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
Seems not to be used here.


```f90
size_basis = size(basis)
```
Gets the size of the `basis` parameter. After some unfruitful research, I made some tests and discovered that this function is, in fact O(1). Or it seems so.

```f90
grad_S     = D_zero
```
`grad_S` is an allocatable, 2D, array of real numbers. And `D_zero` is a constant of value ZERO (yes...).

After more investigation, and testing, I have discovered it is possible to _assign_ a value to arrray. This will make all values become that value. Example: `arr = 5 ! => [5, 5, 5, ...]`. So, the line of code above makes all values of `grad_S` become zero.


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
There is lots of things going on this line. In parts:
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
For each coordinate, do the steps below.


```f90
delta_b = delta * merge(D_one , D_zero , xyz_key == xyz )
```
Very interesting line. The `merge` function will return an array 1s and 0s matching the result of the expression `xyz_key == xyz`. This expression, will return a mask depending on the value of `xyz`. `xyz_key` is a constant array of reals `[1, 2, 3]`.

For example:
- `[1, 2, 3] == 1` will result in a mask `[T, F, F]`;
- The `merge` will check the mask and apply the first argument for the true items and the second for the false ones. So the function will return an array like `[1, 0, 0]`.

`delta` is another constant. It's a value very small, `1d-8`, to be precise.

In the end, `delta_b` will hold the result of multiplying an vector of 1s and 0s to by `delta`.


```f90
system% coord (k,:) = tmp_coord + delta_b
```
Store the new value of the _kth_ coordinate. Basically, sum the value of `delta` to one single value of the coordinate.
