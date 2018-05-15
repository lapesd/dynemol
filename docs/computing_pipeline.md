# Pipeline

Main focus of the pipeline to easily understand the runtime of the program.


## Pseudo code

Explained in C like syntax.
```c
// (1)
for (int time_step = 0; step < total_time; time_step++) {
	// (2)
	for (int atom_i = 0; atom_i < total_atoms; atom_i++) {
		// Ehrenfest (3)
		for (int axis = 0; axis < 3; axis++) {
			// (4)
			Pulay_Overlap(bck);
			Pulay_Overlap(fwd);
			// (5)
			for (int pair = 0; pair < total_pairs; pair++) {
				// (6)
			}
		}
	}
}
```

## Explanation


### (1)

Main loop of the application. It will calculate the state of a big system of molecules, usually some big proteins, for that particular time frame. Each subsequent loop iteration depends on the previous one.

### (2)

For each atom in the system, it will perform some calculations to define the iteration between each pair of atoms.

Because of the iteration is limited between pair of atoms, the computation will decrease in every iteration. For example, if the iteration between atoms 1 and 2 was already calculated, there is no need to calculate the iteration between 2 and 1. According to the teacher, it is only negated.

### (3)

The Ehrenfest function itself. Better explained [here](../procedures/ehrenfest.md).

### (4)

Two calls to the Pulay Overlap function. These two calls are independent and can be parallelized.
