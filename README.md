# bout-build-scripts

### Scripts to compile BOUT++ dependencies, BOUT++ and Hermes-3 on Viking.

Instructions:
- Run "git clone https://github.com/mikekryjak/bout-build-scripts", "cd bout-build-scripts"
- Review the settings of the three build scripts. Ensure that the paths are consistent and the commits are what you want.
- Run "source bout.env" to load the environment modules for the base dependencies (or provide these some other way)
- Stay in the bout-build-scripts directory and run the three build scripts in the right order. Review the corresponding logs to make sure they worked.

Notes:
The scripts assume nothing is cloned/compiled, and will remove existing directories to ensure a clean install. 
This is helpful in avoiding issues when you're compiling for the first time, but will not be helpful if you are changing branches.
In that case, edit the hermes-3 build script to prevent it from removing the directory and cloning it from scratch.

The scripts assume you are in the Viking environment at the University of York and can load the correct dependencies using bout.env.
If you are not on Viking, you will need to provide equivalent base dependencies in your environment. 
Typically this doesn't work first time, which is why saving and reviewing the logs allows you to troubleshoot them one by one.
