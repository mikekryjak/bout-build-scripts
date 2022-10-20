#!/bin/bash

# Log outcome
rm -f storm-log.out # Remove if already exists
exec 3>&1 4>&2 # Trap stdout, stderr etc all at the same time.
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>storm-log.out 2>&1

# Get STORM
git clone https://github.com/boutproject/STORM
git cd STORM

git checkout b1038b2 # Latest master as of 20/10/2022 (STORM v2.2.1)

# Get BoutEquation
cd shared/BoutEquation/

git clone https://github.com/johnomotani/BoutEquation .
git checkout c8b9f8c # Latest master as of 20/10/2022

# Compile
cd ../../STORM

cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/BOUT-dev/build" -DSTORM_BUILD_BOUT=False
cd build
make -j 4
cd ..
