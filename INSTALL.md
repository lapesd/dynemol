# Installation manual

This file contains the installation manual of the Intel Parallel Studio needed for this simulation tool to work in **Unix** systems. For other systems, please refer to the manual at the [get started page](https://software.intel.com/en-us/parallel-studio-xe/documentation/get-started).

-----

## Steps:

1. Register at [Intel's registration website](ttps://software.intel.com/registration/);

2. Download the custom installation method;
	2.1. Intel's installation guide suggests the creation of a folder, `tmp/psxe_staging_area` to extract the installer files into.

3. After step 2, extract the contents of the `.tgz` file downloaded into the `/tmp/psxe_staging_area` (or other name you chose) with `tar -xvzf installer.tgz -C /tmp/psxe_staging_area`;

4. Run `install.sh` located in the `psxe_staging_area` folder;

5. Go through the instructions until you hit the activation menu;
	5.1. Insert the serial you got when you registered at step 1. It should appear in your dashboard in the Intel website. **Your products** section.

6. Advance through the installer until you need to select the following components:
		6.1. Intel C/C++ Compiler;
		6.2. Intel Fortran Compiler;
		6.3. Intel Math Kernel Library;
		6.4. Intel Threading Building Blocks;
		6.5. Intel MPI Library;

7. After selecting the correct components, just run the rest of the installation process.

8. Done!

-----

Please see the compiling manual for more info.
