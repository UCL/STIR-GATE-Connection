#$ -S /bin/bash
#$ -l h_vmem=1G
#$ -l tmem=1G
#$ -l tscratch=1G
#$ -l h_rt=10:00:00
#$ -t 1-2:1
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert TWyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

echo "TASK_ID = " $SGE_TASK_ID
TASK_ID=$SGE_TASK_ID


# Here we assume that we have setup
ActivityFilename=activity.h33
AttenuationFilename=attenuation_GATE.h33

if [ ! -f "$ActivityFilename" ]; then
    echo "ActivityFilena = $ActivityFilename does not exist."
fi

if [ ! -f "$AttenuationFilename" ]; then
    echo "ActivityFilename = $AttenuationFilename does not exist."
fi

## OPTIONAL: Editable fields required by GATE macro scripts
GATEMainMacro="MainGATE.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
StartTime=$(expr $TASK_ID - 1)  ## Start time in GATE time
EndTime=$(expr $TASK_ID)  ## End time in GATE time
StoreRootFilesDirectory=Output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples (eg. D690/mMR).
ROOT_FILENAME=Sim_$TASK_ID

./RunGATE.sh $GATEMainMacro $ROOT_FILENAME $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime

if [ $? -ne 0 ]; then
	echo "Error in RunGATE.sh"
	exit 1
fi

exit 0

exit 0
