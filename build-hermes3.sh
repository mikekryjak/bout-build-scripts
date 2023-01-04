#!/bin/bash
# Do this after cloning from github

# Log outcome
rm -f hermes3-buildlog.out
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>hermes3-buildlog.out 2>&1

branch="power-balance"

cd ../hermes-3
git checkout $branch
git pull
rm -rf $branch

cmake . -B $branch -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/work/e281/e281/mkryjak/BOUT-966bde0/BOUT-dev/build" -DHERMES_BUILD_BOUT=False -DCMAKE_CXX_COMPILER=CC
cd $branch
make -j 8
cd ..