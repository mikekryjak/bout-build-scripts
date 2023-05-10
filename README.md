# bout-build-scripts

### Scripts to compile BOUT++ dependencies, BOUT++ and Hermes-3 on Viking.

#### Instructions:
- Run "git clone https://github.com/mikekryjak/bout-build-scripts", "cd bout-build-scripts"
- Review the settings of the three build scripts. Ensure that the paths are consistent and the commits are what you want.
- Run "source bout.env" to load the environment modules for the base dependencies (or provide these some other way)
- Stay in the bout-build-scripts directory and run the three build scripts in the right order. Review the corresponding logs to make sure they worked.

#### Notes:
##### Existing installations
The scripts assume nothing is cloned/compiled, and will remove existing directories to ensure a clean install. 
This is helpful in avoiding issues when you're compiling for the first time, but will not be helpful if you are changing branches.
In that case, edit the hermes-3 build script to prevent it from removing the directory and cloning it from scratch.

##### Environment
The scripts assume you are in the Viking environment at the University of York and can load the correct dependencies using bout.env.
If you are not on Viking, you will need to provide equivalent base dependencies in your environment. 
Typically this doesn't work first time, which is why saving and reviewing the logs allows you to troubleshoot them one by one.

##### PETSc and Hypre
The benefit of these scripts is that PETSc is downloaded, compiled and linked automatically and you do not depend on external installations of PETSc.
It can be challenging to make those work because they could be compiled with slightly different options - this can cause a lot of problems.
PETSc is configured to download Hypre and it will be available for use. When compiling BOUT++ you will see "HYPRE support: OFF" in the console dump - 
this is because it's referring to the presence of a standalone Hypre installation. With these scripts, Hypre is coming bundled with PETSc and does not show here.

##### Hermes-3 and BOUT++
By default Hermes-3 will download and compile BOUT++ on its own. Unfortunately this is done in a way that requires an existing PETSc installation 
which for the reasons discussed above can be problematic. This is why these scripts make BOUT++ separately, compile Hermes-3 with the flag "DHERMES_BUILD_BOUT=False" and link it to the already compiled BOUT++ install.


