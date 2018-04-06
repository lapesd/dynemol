# Installation manual

This file contains the installation manual of the Intel Parallel Studio needed for this simulation tool to work in **Unix** systems. For other systems, please refer to the manual at the [get started page](https://software.intel.com/en-us/parallel-studio-xe/documentation/get-started).

---

## Steps:

1. Register at Intel's registration [website](https://software.intel.com/registration);

2. Download the custom installation method;
    - Intel's installation guide suggests the creation of a folder, `tmp/psxe_staging_area` to extract the installer files into.

3. After step 2, extract the contents of the `.tgz` file downloaded into the `/tmp/psxe_staging_area` (or other name you chose) with `tar -xvzf installer.tgz -C /tmp/psxe_staging_area`;

4. Run `install.sh` located in the `psxe_staging_area` folder;

5. Go through the instructions until you hit the activation menu;
    - Insert the serial you got when you registered at step 1. It should appear in your dashboard in the Intel website. **Your products** section.

6. Advance through the installer until the component selection screen. You need to select the following components:
    - Intel C/C++ Compiler;
    - Intel Fortran Compiler;
    - Intel Math Kernel Library;
    - Intel Threading Building Blocks;
    - Intel MPI Library;

7. After selecting the correct components, just run the rest of the installation process.

8. Done!

-----

# TODO
Please see the compiling manual for more info.
