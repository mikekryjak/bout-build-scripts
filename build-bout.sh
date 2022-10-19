#!/bin/bash

# Log outcome
rm -f bout-buildlog.out # Remove if already exists
exec 3>&1 4>&2 # Trap stdout, stderr etc all at the same time.
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>bout-buildlog.out 2>&1

# exit when any command fails
set -e

# Get BOUT++ (replace branch with your branch of choice)
git clone -b 9071038 https://github.com/boutproject/BOUT-dev

cd BOUT-dev

git submodule update --init --recursive

PETSC_DIR=$PWD/../dependencies/petsc-build PETSC_ARCH="" cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCHECK=0 -DBOUT_DOWNLOAD_NETCDF_CXX4=ON -DBOUT_DOWNLOAD_SUNDIALS=ON -DBOUT_USE_PETSC=ON -DBOUT_IGNORE_CONDA_ENV=ON
cmake --build build -j 4
