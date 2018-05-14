# Questions

File created to store questions about the intrinsics of the software.


## Ehrenfest

1. Are the calls to this procedure independent?
  1. The `system` parameter is the only one that has `intent(inout)`. This means it can be changed. Does these possible changes have any effect in subsequent calls? In other words, does the order in which this procedure is called alter the results?
2. Are the calls to `Overlap_Matrix` subroutine, which calls `Pulay_Overlap` independent?
  1. Does the values passed to each one of the calls are changed inside the procedure?
  - **Answer**: After analysis, the only ones that change are `S_fwd` and `S_bck`. The rest of the arguments are all `intent(in)`. So, there shouldn't be any problems.
  - **Options**: So, this calls appear to be independent of each other. They could be parallelized.
      - This section could be separated into 2 threads, each one would calculate each call to `Overlap_Matrix` independently and in parallel (`workshare` directive?).


## Pulay_Overlap

1. Are the calls to this procedure independent?
2. Are the loops inside this procedure independent? In other words, is it possible to execute this loop in any order? Are the modifications made in the `S_matrix` argument always done in different places (avoid data racing)?
3. In the generation procedures, the ones that prepare lots of values to be calculated in the matrix operations. Are they independent?
  - If they are, `workshare` construct.
4. Same as the question above, but for the allocation/deallocation procedures.


## Solap

1. Same as the others. Are the calculations made inside this procedure independent?
2. Are the loops inside this procedure independent?

