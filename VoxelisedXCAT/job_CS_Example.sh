#$ -S /bin/bash
#$ -l h_vmem=1G
#$ -l tmem=1G
#$ -l tscratch=1G
#$ -l h_rt=2:00:00
#$ -t 1-2:1
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert TWyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

echo "SGE_TASK_ID = " $SGE_TASK_ID

./ExampleSTIR-GATE.sh $SGE_TASK_ID

exit 0
