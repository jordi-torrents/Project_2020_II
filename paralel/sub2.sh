#!/bin/bash
#BSUB -n 356
#BSUB -W 04:00
##BSUB -o time.out
##BSUB -e time.err
#BSUB -q training
module purge
module load intel openmpi
mpirun dynamics.exe input_file.dat > ts_test/time356.log
