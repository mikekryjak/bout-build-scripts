#!/bin/bash

# Log outcome
rm -f dependencies-log.out # Remove if already exists
exec 3>&1 4>&2 # Trap stdout, stderr etc all at the same time.
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>dependencies-log.out 2>&1

# exit when any command fails
set -e

# Build dependencies that BOUT++'s CMake configuration does not handle yet
rm -f dependencies # Delete if already exists
mkdir dependencies
cd dependencies

DEPS_ROOT=$(pwd)

# PETSc
# See https://stackoverflow.com/a/13864829 for testing if variable is set
if [ -z ${PETSC_DIR+x} ]; then
  unset PETSC_DIR
fi
if [ -z ${PETSC_ARCH+x} ]; then
  unset PETSC_ARCH
fi

mkdir petsc-build
wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.17.4.tar.gz
tar xzf petsc-3.17.4.tar.gz
cd petsc-3.17.4
./configure COPTFLAGS="-O3" CXXOPTFLAGS="-O3" FOPTFLAGS="-O3" --download-hypre --with-debugging=0 --prefix=../petsc-build
make -j 4 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all
make -j 4 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt install
make -j 4 PETSC_DIR=$PWD/../petsc-build PETSC_ARCH="" check

cd $DEPS_ROOT
