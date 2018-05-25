#!/bin/bash

# Stop on error
set -e

help() {
    echo ''
    echo 'Script that auto generates profiling info for the program'
    echo 'What it does:'
    echo '    - Profile advanced hotspots'
    echo '    - Profile hpc performance'
    echo '    - Profile concurrency'
    echo ''
    echo 'Usage:'
    echo ''
    echo 'bash profile.sh dir omp mkl'
    echo ''
    echo '    dir: Name of output directory to save data. The dir will be'
    echo '         created inside the profile folder'
    echo '    omp: Number of OMP threads'
    echo '    mkl: number of MKL threads'
    echo ''
}

if [ $# -ne 3 ]
then
    help
    exit 1
fi

OUT_FOLDER=$1

export OMP_NUM_THREADS=$2
export MKL_NUM_THREADS=1

export KMP_HW_SUBSET=$2,$3
export KMP_AFFINITY='verbose,granularity=fine,compact'

# For some motive, I need to call vtune from inside the folder of the program
# itself
cd dynemol


# Hotspots
amplxe-cl -collect hotspots \
    -data-limit=30000 \
    -r ../profile/$OUT_FOLDER/hotspots \
    -verbose \
    -no-summary \
    -- ./a
echo ''
echo '========================='
echo 'HOTSPOTS PROFILE FINISHED'
echo '========================='
echo ''

# HPC performance
amplxe-cl -collect hpc-performance \
    -data-limit=30000 \
    -r ../profile/$OUT_FOLDER/hpc \
    -verbose \
    -no-summary \
    -- ./a
echo ''
echo '================================'
echo 'HPC-PERFORMANCE PROFILE FINISHED'
echo '================================'
echo ''

# Concurrency
amplxe-cl -collect concurrency \
    -data-limit=30000 \
    -r ../profile/$OUT_FOLDER/concurrency \
    -verbose \
    -no-summary \
    -- ./a
echo ''
echo '============================'
echo 'CONCURRENCY PROFILE FINISHED'
echo '============================'
echo ''
