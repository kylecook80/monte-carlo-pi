#!/bin/bash
#SBATCH -J mcsim-test
#SBATCH -n 8
#SBATCH -e errfile.%j
#SBATCH -o outfile.%j
#SBATCH -D /media/homedirs/kcook

/usr/lib64/openmpi/bin/mpicc monte_carlo_pi.c -lm -o pi
/usr/lib64/openmpi/bin/mpirun ~/pi 1000000000 256
