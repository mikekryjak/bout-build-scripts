# bout-build-scripts - OLD DOCUMENTATION, NEEDS UPDATING

Scripts for downloading and compiling BOUT++ along with SUNDIALS and PETSc for *Ancalagon*.
Based on John Omotani's scripts (https://github.com/BOUT-dev/BOUT-configs)

## Instructions:
- Ensure you have Python packages boututils and gitpython. 
- $ git clone https://github.com/mikekryjak/bout-build-scripts
- $ source bout.env # load dependencies from HPC  
- $ sh build-all.sh

## What each file does (in the order of execution):
- bout.env contains module load commands for all the dependencies required from the HPC environment
- build-bout.sh downloads and compiles BOUT++ (incl. SUNDIALS)
- build-storm.sh downloads and compiles STORM including its dependency BoutEquation

## Diagnostic output:
- The BOUT++ installation is logged in "bout-log.out"
- The STORM installation is logged in "storm-log.out"

## Notes
- All the dirs and logs are automatically deleted each time you run the scripts to aid in reproducibility by ensuring a clean compile.
- ClangFormat is missing and BOUT++ will complain about it. This is only needed for development so it's OK.
- You don't need to worry about SUNDIALS at all as this is downloaded by BOUT++ automatically.
- All the GitHub repos (BOUT++, STORM, BoutEquation) are hardcoded to latest master branches as of 20/10/2022. These can be changed by editing the script.