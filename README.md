# bout-build-scripts

Scripts for downloading and compiling BOUT++ along with SUNDIALS and PETSc for Ancalagon.
Hypre is provided as part of PETSc and not as a separate package.
By default the scripts will clone the Hermes-3 compatible branch, change this if you want another.
Use the build-all-slurm.sh script to compile everything on compute nodes - this is necessary to avoid the memory allocation limitation preventing compilation tests from running (these are not critical but useful for debugging). Note that we are running on the debug partition as all the other partitions have no access to internet and therefore can't download PETSc.
