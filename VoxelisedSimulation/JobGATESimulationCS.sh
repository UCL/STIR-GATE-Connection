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

## This is an example job submission script for the UCL Computer Science Cluster to perform multiple GATE simulations. 
## Each simulatuion is given a unique variable $SGE_TASK_ID by the scheduler, which is an int.
## Using $TASK_ID, the start and end times of each simulation are staggered by staggered by 1 second.
## Each simulatiuon will output a unique root file, which can be later unlisted.

echo "TASK_ID = " $SGE_TASK_ID
TASK_ID=$SGE_TASK_ID

echo "Script initialised:" `date +%d.%m.%y-%H:%M:%S`

## Sleep for up to 5 minutes to stagger executable loading
SLEEPTIME=$((1 + RANDOM % 300))
echo "Sleeping ${SLEEPTIME} seconds"  
sleep ${SLEEPTIME}

# Here we assume that we have setup the activity and attenuation
ActivityFilename=activity.h33
AttenuationFilename=attenuation_GATE.h33

if [ ! -f "$ActivityFilename" ]; then
    echo "ActivityFilename = $ActivityFilename does not exist."
fi

if [ ! -f "$AttenuationFilename" ]; then
    echo "AttenuationFilename = $AttenuationFilename does not exist."
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

echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0
