#$ -S /bin/bash
#$ -l h_vmem=1G
#$ -l tmem=1G
#$ -l tscratch=10G
#$ -l h_rt=10:00:00
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert TWyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

./ExampleSTIR-GATE.sh

exit 0
