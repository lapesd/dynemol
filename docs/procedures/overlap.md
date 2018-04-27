
# Overlap

File created to document the Overlap_Matrix subroutine. Located in [overlap_D.f](../dynemol/overlap_D.f).


## Parameters


### system

```f90
type(structure), intent(in) :: system
```
Describe the universe of the model being simulated. It's parameters vary between constants of this said universe to big allocatable arrays to be used to store many of its values.

It is fair to note that it only stores default data types. Such as `real`, `complex` etc.


### basis

```f90
type(STO_basis), intent(in) :: basis(:)
```
Describes many values to be used in the calculations. It is a simpler custom type than the `structure` one. It does not have allocatable arrays and only seems to store a finite set of variables. All of them, default data types.


### S_matrix

```f90
real*8, allocatable, intent(inout) :: S_matrix(:,:)
```
Matrix of values to perform some operation, defined by the `purpose` parameter.


### purpose

```f90
character(len=*), optional, intent(in) :: purpose
```
Name of operation to perform. It can be one of the following values:
- FMO
- GA-CG
- Pulay

If no purpose is provided, it will build a matrix and generate an structure. Whatever that means.


### site

```f90
integer, optional, intent(in) :: site
```
Seems to be the index of the atom which we want to calculate the value of.


## Return

### S_matrix

Matrix after applying the defined operation.


## Code

Differently than the [Ehrenfest](ehrenfest.md) documentation, there won't be a line-by-line explanation here. We are only interested in the `Pulay_overlap` subroutine.

Quick note: It is going to be a wild-ride...

Quick note 2: It is very likely that here is the best place for improvement.

I think it will be an easier way to grasp the scope of this subroutine by listing all the main points of it:

- 6-deep do loop;
  - Outer do loop with `OMP parallel do` directive with **29** private variables. Now removed for testing.
- `goto`s;
- Factorials calculation using do loops, 3 deep;
- Calls to some other procedures:
  - `RotationOverlap` subroutine. Which calls `rotar` subroutine;
    - `rotar` calculates rotation matrix for some specific transformation. It calls the `dlmn` subroutine;
    	- `dlmn` is an auxiliary subroutine to `rotar`. It performs some matrix calculations;
  - 5 loop deep, there is a call to the subroutine `solap` which in itself has some 4 deep do loops performing lots of calculations;
  - 5 and 4 loops deep, there is also `forall`s uses.


## Notes


### Complexity

This is probably the bottleneck of this program. As this function is called on every iteration of the main loop, for every atom.

Assuming each loop iterates from 1 to N. At some point, we have a 10 deep loop. Possibly resulting in a N^10 complexity, which is impressive.


### Options

There are some approaches to have a significant performance boost in this section:
- Study the data received by the functions. Which will be a very slow moving approach:
  - What kind of matrices are we dealing with?
  - Should we consider threads?
  - Are the operations thread safe? Are there any racing conditions?
  - Should we consider a more direct approach? Throwing everything into GPUs?
- Code refactoring. Very, very, very slow approach to this problem:
  - Will need understanding of all the operations being performed;
  - What is the input/output? Which implies the understanding of the first item, which already is a slow moving approach;
- Find better uses of the `OMP` directives:
  - It requires, to some degree, a basic understanding of the inputs of the function, but not as deep as the first and seconds items of this list suggests;
- Use CUDA:
  - Needs some studying.
