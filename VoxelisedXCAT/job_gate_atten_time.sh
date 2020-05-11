
#$ -S /bin/bash
#$ -l h_vmem=1G
#$ -l tmem=1G
#$ -l tscratch=10G
#$ -l h_rt=100:00:00
#$ -t 1-20:1
#-tc 100
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Ludovica Brusaferri
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

sleep $((1 + RANDOM % 60))

startTime=$(($(($SGE_TASK_ID-1))))
endTime=$(($(($SGE_TASK_ID))))

#StoreRootFilesDirectory=$PWD
StoreRootFilesDirectory=/scratch0/$USER/GATEJOB_$JOB_ID

if [ ! -d $StoreRootFilesDirectory ]; then
mkdir -p $StoreRootFilesDirectory

fi

./create_root_and_unlist.sh $SGE_TASK_ID $startTime $endTime $StoreRootFilesDirectory
















































