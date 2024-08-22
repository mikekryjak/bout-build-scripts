#!/bin/bash

####################################################################################
# This script won't change Hermes-3 branches, it'll get the master by default.
# If you want to change branches, do this manually and compile as normal.
####################################################################################

# SETTINGS
BOUT_BUILD_NAME="build-7d261d4"
HERMES_BUILD_NAME="build-mc-master"

LIMITER="MC"

FRESH=false    # If true, remove build dir and start from scratch, can help with issues but slower.
BUILD_TYPE="Release"

HERMES_DIR=$PWD/../hermes-3
HERMES_BUILD_DIR=$HERMES_DIR/$HERMES_BUILD_NAME
PETSC_DIR=$PWD/../petsc-bout/petsc-build     # PETSc directory. Important! 
BOUT_DIR=$PWD/../BOUT/BOUT-dev
BOUT_BUILD_DIR=$BOUT_DIR/$BOUT_BUILD_NAME


# Log outcome
rm -f hermes3-buildlog.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>hermes3-buildlog.out 2>&1

# Create Hermes-3 directory and clone git repo if necessary
mkdir -p $HERMES_DIR  
cd $HERMES_DIR
if [ ! -d "hermes-3" ]; then
    echo "Hermes-3 directory doesn't exist, cloning..."
    git clone https://github.com/bendudson/hermes-3
fi

# Fresh build directory if necessary
if [ "$FRESH" = true ]; then
    rm -rf $HERMES_BUILD_DIR
fi

PETSC_DIR=$PETSC_DIR PETSC_ARCH="" cmake . -B ${HERMES_BUILD_NAME} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_PREFIX_PATH="${BOUT_BUILD_DIR}" -DHERMES_BUILD_BOUT=False -DHERMES_SLOPE_LIMITER=${LIMITER}
cd $HERMES_BUILD_NAME
make -j 8
cd ..

