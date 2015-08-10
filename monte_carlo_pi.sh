#!/bin/bash

#SBATCH -J mcsim-test
#SBATCH -n 160
#SBATCH -e errfile.%j
#SBATCH -o outfile.%j

module load gcc
module load openmpi

cd /home/kcook/monte_carlo_pi/bin/
mpirun ./hello_world-0.1 100000000000 256
