#!/bin/bash

# SETTINGS
BOUT_COMMIT="c4c149a"
BOUT_DIR=$PWD/../BOUT-$BOUT_COMMIT # Make sure this is the same as in build-bout.sh

# Log outcome
rm -f dependencies-buildlog.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>dependencies-buildlog.out 2>&1

# exit when any command fails
set -e

rm -rf $BOUT_DIR # Remove if already exists
mkdir $BOUT_DIR
cd $BOUT_DIR

# Build dependencies that BOUT++'s CMake configuration does not handle yet
rm -rf dependencies # Remove if already exists
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

PETSC_VERSION="3.23.3"

rm -rf "petsc-$PETSC_VERSION.tar.gz"
wget "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-$PETSC_VERSION.tar.gz"
rm -rf "petsc-$PETSC_VERSION"
tar -xf "petsc-$PETSC_VERSION.tar.gz"
cd "petsc-build"
./configure \
    COPTFLAGS="-O3" \
    CXXOPTFLAGS="-O3" \
    FOPTFLAGS="-O3"\
    --with-fortran-bindings=0 \
    --with-debugging=0 \
    --with-mpi=yes \
    --download-hypre \
    --download-make \
    --download-openblas=1 \
    --download-metis \
    --download-parmetis \
    --download-zfp \
    --download-strumpack \
    --download-scalapack \
    --download-ptscotch \
    --download-mumps \
    --download-superlu \
    --download-suitesparse \
    --download-superlu_dist \
    --download-slepc \
    --download-hpddm \
    --with-make-np=4    # This makes sure it's parallel for all dependencies too

make PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all

cd $DEPS_ROOT
