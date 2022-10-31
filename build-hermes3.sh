#!/bin/bash
# Do this after cloning from github

# Log outcome
rm -f hermes3-buildlog.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>hermes3-buildlog.out 2>&1

cd hermes-3

cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/users/mjk557/scratch/BOUT-hermes3/BOUT-dev/build" -DHERMES_BUILD_BOUT=False
cd build
make -j 8
cd ..