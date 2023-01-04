#!/bin/bash
# Log outcome
rm -f bout-buildlog.out # Remove if already exists
exec 3>&1 4>&2 # Trap stdout, stderr etc all at the same time.
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>bout-buildlog.out 2>&1

# exit when any command fails
set -e
echo $PWD
cd ../BOUT-966bde0

# Get BOUT++ (replace branch with your branch of choice)
rm -rf BOUT-dev # Remove if already exists
git clone https://github.com/boutproject/BOUT-dev
cd BOUT-dev
git checkout 966bde0 # Hermes branch

git submodule update --init --recursive

PETSC_DIR=$PWD/../dependencies/petsc-build PETSC_ARCH="" cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE="-fast -DNDEBUG" -DCHECK=0 -DCMAKE_CXX_COMPILER=CC -DCMAKE_FTN_COMPILER=ftn -DBOUT_DOWNLOAD_SUNDIALS=ON -DBOUT_USE_PETSC=ON -DBOUT_IGNORE_CONDA_ENV=ON

cmake --build build -j 16

