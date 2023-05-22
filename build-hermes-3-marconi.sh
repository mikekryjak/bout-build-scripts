#!/bin/bash

set -e

TOP_DIR=$(pwd)
DEPS_DIR=$TOP_DIR/deps

BOUT_COMMIT=dfef9f6


# Required modules
module load env-skl profile/advanced intel/pe-xe-2020--binary gnu/7.3.0 openmpi/3.1.4--gnu--7.3.0 mkl/2020--binary cmake python/3.9.4



# Dependencies
cd $TOP_DIR
rm -rf $DEPS_DIR
mkdir -p $DEPS_DIR
cd $DEPS_DIR

mkdir fftw-build
wget https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
rm fftw-3.3.10.tar.gz
cd fftw-3.3.10
./configure --prefix $DEPS_DIR/fftw-build --enable-shared --enable-sse2 --enable-avx --enable-avx2 --enable-avx512 --enable-avx-128-fma
make -j 16
make install

cd $DEPS_DIR
mkdir hdf5-build
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.1/src/hdf5-1.12.1.tar.bz2
tar xjf hdf5-1.12.1.tar.bz2
rm hdf5-1.12.1.tar.bz2
cd hdf5-1.12.1
./configure --prefix $DEPS_DIR/hdf5-build --enable-build-mode=production
make -j 16
make install

cd $DEPS_DIR
mkdir netcdf-build
wget https://downloads.unidata.ucar.edu/netcdf-c/4.8.1/netcdf-c-4.8.1.tar.gz
tar xzf netcdf-c-4.8.1.tar.gz
rm netcdf-c-4.8.1.tar.gz
cd netcdf-c-4.8.1
CPPFLAGS="-I$DEPS_DIR/hdf5-build/include" LDFLAGS="-L$DEPS_DIR/hdf5-build/lib/" ./configure --prefix=$DEPS_DIR/netcdf-build
make -j 16
make install

cd $DEPS_DIR
wget https://downloads.unidata.ucar.edu/netcdf-cxx/4.3.1/netcdf-cxx4-4.3.1.tar.gz
tar xzf netcdf-cxx4-4.3.1.tar.gz
rm netcdf-cxx4-4.3.1.tar.gz
cd netcdf-cxx4-4.3.1
CPPFLAGS="-I$DEPS_DIR/hdf5-build/include -I$DEPS_DIR/netcdf-build/include" LDFLAGS="-L$DEPS_DIR/hdf5-build/lib/ -L$DEPS_DIR/netcdf-build/lib/" ./configure --prefix=$DEPS_DIR/netcdf-build
make -j 16
make install

cd $DEPS_DIR
# See https://stackoverflow.com/a/13864829 for testing if variable is set
if [ -z ${PETSC_DIR+x} ]; then
  unset PETSC_DIR
fi
if [ -z ${PETSC_ARCH+x} ]; then
  unset PETSC_ARCH
fi
mkdir petsc-build
wget https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.16.3.tar.gz
tar xzf petsc-3.16.3.tar.gz
rm petsc-3.16.3.tar.gz
cd petsc-3.16.3
./configure COPTFLAGS="-O3" CXXOPTFLAGS="-O3" FOPTFLAGS="-O3" --download-hypre --with-debugging=0 --prefix=../petsc-build
make -j 16 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt all
make -j 16 PETSC_DIR=$PWD PETSC_ARCH=arch-linux-c-opt install
make -j 16 PETSC_DIR=$PWD/../petsc-build PETSC_ARCH="" check



# BOUT++

cd $TOP_DIR

git clone https://github.com/boutproject/BOUT-dev.git
cd BOUT-dev
git checkout $BOUT_COMMIT
git submodule update --init --recursive

cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCHECK=0 -DBOUT_DOWNLOAD_SUNDIALS=ON -DBOUT_USE_PETSC=ON -DPETSC_DIR=$DEPS_DIR/petsc-build -DPETSC_ARCH="" -DBOUT_USE_HDF5=OFF -DNC_CONFIG=$DEPS_DIR/netcdf-build/bin/nc-config -DNCXX4_CONFIG=$DEPS_DIR/netcdf-build/bin/ncxx4-config -DFFTW_ROOT=$DEPS_DIR/fftw-build -DBOUT_UPDATE_GIT_SUBMODULE=False

cmake --build build -j 16



# Hermes-3
cd $TOP_DIR
git clone https://github.com/bendudson/hermes-3
cd hermes-3

cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$TOP_DIR/BOUT-dev/build -DHERMES_BUILD_BOUT=False -DNC_CONFIG=$DEPS_DIR/netcdf-build/bin/nc-config -DNCXX4_CONFIG=$DEPS_DIR/netcdf-build/bin/ncxx4-config -DFFTW_ROOT=$DEPS_DIR/fftw-build -DBOUT_UPDATE_GIT_SUBMODULE=False

cd build
make -j 16
