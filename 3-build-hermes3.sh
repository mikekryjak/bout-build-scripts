#!/bin/bash

# SETTINGS
BOUT_COMMIT="7152948"  # Make sure this is the same as in build-bout.sh
BOUT_DIR=$PWD/../BOUT-$BOUT_COMMIT # Make sure this is the same as in build-bout.sh
HERMES_BRANCH="master"
BUILD_NAME="master"   # Your chosen name of the build folder

# Log outcome
rm -f hermes3-buildlog.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>hermes3-buildlog.out 2>&1

cd ..
# Comment the below two lines out if you're just switching branches
################################################
rm -rf hermes-3 # Ensure you start from scratch for a clean install
git clone https://github.com/bendudson/hermes-3
################################################
cd hermes-3
git checkout $HERMES_BRANCH
git pull
rm -rf $BUILD_NAME

cmake . -B $BUILD_NAME -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="${BOUT_DIR}/BOUT-dev/build" -DHERMES_BUILD_BOUT=False -DHERMES_SLOPE_LIMITER=MinMod
cd $BUILD_NAME
make -j 8
cd ..
