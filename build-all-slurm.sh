#!/bin/bash
#SBATCH -J BOUTcompile
#SBATCH -N1 -n4
#SBATCH -e %x.e%j           # stderr output goes to jobname.eXXXX file
#SBATCH -o %x.o%j           # stdout output goes to jobname.oXXXX file
#SBATCH -p debug
#SBATCH -t 1:00:00

echo Job name $SLURM_JOB_NAME
echo Job id $SLURM_JOB_ID

ulimit -l unlimited # Need this to avoid memory allocation limits.

date
sh build-all.sh
date
