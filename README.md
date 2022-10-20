# bout-build-scripts - OLD DOCUMENTATION, NEEDS UPDATING

Scripts for downloading and compiling BOUT++ along with SUNDIALS and PETSc for *Ancalagon*.
Based on John Omotani's scripts (https://github.com/BOUT-dev/BOUT-configs)

## Instructions:
- Run git clone https://github.com/mikekryjak/bout-build-scripts
- run sh build-all.sh
- Run sbatch build-all-slurm.sh

## What each file does (in the order of execution):
- bout.env contains module load commands for all the dependencies required from the HPC environment
- build-all-slurm.sh executes build-all.sh on the debug node with 4 cores
- build-all.sh loads the environment (dependency modules) contained in bout.env
- build-dependencies.sh downloads and compiles PETSc with the correct settings (incl. Hypre)
- build-bout.sh downloads and compiles BOUT++ (incl. SUNDIALS) and links it to PETSc built in the previous step

## Diagnostic output:
- The PETSc installation is logged in "dependencies-log.out"
- The BOUT++ installation is logged in "bout-buildlog.out"
- Additionally the SLURM job output will be logged in "BOUTcompile.exxxxx" and BOUTcompile.oxxxxx" for the stderr and stdout respectively

## Notes
- All the dirs and logs (apart from SLURM logs) are automatically deleted each time you run the scripts to aid in reproducibility by ensuring a clean compile.
- ClangFormat is missing and BOUT++ will complain about it. This is only needed for development so it's OK.
- The PETSc version is not the latest. This is OK.
- BOUT++ will complain it has "HYPRE support = OFF". This is because it is using Hypre through PETSc and not individually.
- You don't need to worry about SUNDIALS at all as this is downloaded by BOUT++ automatically.
- When modifying the CMake command pay *extreme attention* to the details. PETSc dir must be set in the same line before the cmake command. All subsequent flags must be on the same line as line continuation characters break it.
- The scripts work for BOUT next (latest "beta" version) as of 19/10/2022. This may change in the future.