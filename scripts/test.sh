#!/bin/bash

# Stops when error is found
set -e

# Prints help message
help() {
    echo ''
    echo 'Script created to automate tests for the project.'
    echo 'What it does:'
    echo '  - "make clean"'
    echo '  - Compiles'
    echo '  - Run once'
    echo '  - Compare outputs'
    echo ''
    echo 'Usage:'
    echo ''
    echo 'sh test.sh arg1 arg2'
    echo ''
    echo '  arg1:   Number of OMP threads'
    echo '  arg2:   Number of MKL threads'
    echo ''
}

# Check for args
if [ $# -ne 2 ]
then
    help
    exit
fi

# Enviroment vaiables used to test
export OMP_NUM_THREADS=$1
export MKL_NUM_THREADS=$2

cd dynemol

# Run with perf
perf stat -d ./a

# Files to test
FRAMES_EXPECTED=expected.pdb
FRAMES_RESULT=frames-MM.pdb

# Compare outputs
diff $FRAMES_RESULT $FRAMES_EXPECTED
if [ $? -ne 0 ]
then
    echo ""
    echo "=============================="
    echo "Test failed (see errors above)"
    echo "=============================="
    echo ""
else
    echo ""
    echo "==============="
    echo "Test successful"
    echo "==============="
    echo ""
fi
