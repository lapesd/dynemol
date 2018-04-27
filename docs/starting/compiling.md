
# Compiling and running

Little tutorial on how to compile and run the software.


## Compiling

After following the instructions in the [installation](install.md) manual, you should have the `ifort` compiler (almost) good to go.

If you are seeing the `ifort: command not found` message, it is because the environment is not properly set up. To fix it, just source the Intel provided files to apply the environment to your terminal. If you followed the installation manual, it is probably located in the `/opt` folder. So, running `source /opt/intel/bin/compilervars.sh intel64` should make everything ok.

After that, it is as easy as running `make` into the [dynemol](../dynemol) folder.

That's it!


## Running

### New way

Inside the [dynemol](../dynemol) folder, simply run:

```bash
make ret make && ./a
```

This command does the exact same thing the old way does, but automatically.


### Old way

Take one of the `.tar` files in the [inputs](../dynemol/inputs) folder and decompress it to the [dynemol](../dynemol) folder. You can use `tar -xvf path/to/inputs/file.tar -C path/to/dynemol`, if you are not familiar with the `tar` command.

After that, just recompile and run the program with:

```bash
make && ./a
```
