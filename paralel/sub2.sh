#!/bin/bash
#BSUB -n 128
##BSUB -o %J.out
##BSUB -e %J.err
#BSUB -W 01:00
module purge
module load intel openmpi
mpirun dynamics.exe input_file.dat > time128.log
