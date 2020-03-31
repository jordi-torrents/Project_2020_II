#!/bin/bash
#BSUB -n 300
##BSUB -o %J.out
##BSUB -e %J.err
#BSUB -W 01:00
module purge
module load intel openmpi
mpirun dynamics.exe input_file.dat > time.log
