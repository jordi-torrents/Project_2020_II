#!/bin/bash
#BSUB -n 1
#BSUB -o %J.out
#BSUB -e %J.err
#BSUB -W 01:00
module purge
./dynamics_seq.exe input_file.dat > time1.log
