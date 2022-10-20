
git clone https://github.com/boutproject/STORM
git cd STORM

git checkout b1038b2 # Latest master as of 20/10/2022 (STORM v2.2.1)

cd shared/BoutEquation/

git clone https://github.com/johnomotani/BoutEquation .
git checkout c8b9f8c # Latest master as of 20/10/2022

cd ../../STORM

cmake . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/BOUT-dev/build" -DSTORM_BUILD_BOUT=False
cd build
make -j 4
cd ..
