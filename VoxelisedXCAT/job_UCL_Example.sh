#$ -S /bin/bash
#$ -l mem=1G
#$ -l tmpfs=1G
#$ -l h_rt=10:00:00
#$ -t 1-2
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert TWyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

echo "SGE_TASK_ID = " $SGE_TASK_ID

./ExampleSTIR-GATE.sh $SGE_TASK_ID

exit 0
