#!/bin/bash

# SETTINGS
# BOUT_COMMIT="7d261d4"              # Branch name or commit hash of BOUT++ to use
BOUT_DIR=$PWD/../BOUT         # BOUT++ will be cloned into this directory (default: root dir of current script)

# BUILD_NAME="build-7d261d4-sundialslog"
BUILD_NAME="build-hermes3temp-sundialslog"
# BUILD_NAME="build-7d261d4"
# BUILD_NAME="build-7d261d4-test"    

CHECK=0    # Higher check level means more debugging
FRESH=true    # If true, remove build dir and start from scratch, can help with issues but slower.
PETSC_DIR=$PWD/../petsc-bout/petsc-build     # PETSc directory. Important! 

BUILD_DIR=$BOUT_DIR/${BUILD_NAME}

# Log outcome
rm -f bout-buildlog.out # Remove if already exists
exec 3>&1 4>&2 # Trap stdout, stderr etc all at the same time.
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>bout-buildlog.out 2>&1

# exit when any command fails
set -e

# If BOUT++ directory is empty, clone it
echo $BOUT_DIR
mkdir -p $BOUT_DIR   # -p flag creates it only if it doesn't exist
cd $BOUT_DIR
if [ ! -d "BOUT-dev" ]; then
    echo "BOUT-dev directory doesn't exist, cloning..."
    git clone https://github.com/boutproject/BOUT-dev
fi

# Select version 
cd $BOUT_DIR/BOUT-dev
# git checkout $BOUT_COMMIT 

# Remove build directory if fresh start
if [ "$FRESH" = true ]; then
    rm -rf $BUILD_DIR
fi

# Important: PETSC_DIR and PETSC_ARCH must be on the same line as cmake
PETSC_DIR=$PETSC_DIR PETSC_ARCH="" cmake . -B ${BUILD_NAME} -DCMAKE_BUILD_TYPE=Release -DCHECK=${CHECK} -DBOUT_DOWNLOAD_SUNDIALS=ON -DSUNDIALS_LOGGING_LEVEL=4 -DBOUT_USE_PETSC=ON -DBOUT_DOWNLOAD_NETCDF_CXX4=ON -DBOUT_IGNORE_CONDA_ENV=ON

cmake --build ${BUILD_NAME} -j 8

