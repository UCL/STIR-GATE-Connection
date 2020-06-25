#$ -S /bin/bash
#$ -l mem=1G
#$ -l tmpfs=1G
#$ -l h_rt=10:00:00
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert TWyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

./ExampleSTIR-GATE.sh

exit 0
