#!/bin/bash
#BSUB -n 2
#BSUB -o %J.out
#BSUB -e %J.err
#BSUB -W 01:00
module purge
module load intel openmpi
time mpirun mulmat.exe > results.log
