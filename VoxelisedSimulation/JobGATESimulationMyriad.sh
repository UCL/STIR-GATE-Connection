#$ -S /bin/bash
#$ -l mem=1G
#$ -l tmpfs=1G
#$ -l h_rt=10:00:00
#$ -t 1-2
#$ -cwd
#$ -j y
#$ -N GateSim

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## This is an example job submission script for the UCL Myriad Cluster to perform multiple GATE simulations. 
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
ActivityFilename=activity_GATE.h33
AttenuationFilename=attenuation_GATE.h33

if [ ! -f "$ActivityFilename" ]; then
    echo "ActivityFilename = $ActivityFilename does not exist."
fi

if [ ! -f "$AttenuationFilename" ]; then
    echo "ActivityFilename = $AttenuationFilename does not exist."
fi

## OPTIONAL: Editable fields required by GATE macro scripts
TimePerGATESim=10  # in seconds
GATEMainMacro="MainGATE.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
StoreRootFilesDirectory=Output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples (eg. D690/mMR).
ROOT_FILENAME=Sim_$TASK_ID

## Start and End time in GATE time
StartTime="$(echo $TASK_ID $TimePerGATESim | awk '{ tmp=(( $1 - 1 ) * $2) ; printf"%0.0f", tmp }')"
EndTime="$(echo $TASK_ID $TimePerGATESim | awk '{ tmp=( $1  * $2) ; printf"%0.0f", tmp }')"


./RunGATE.sh $GATEMainMacro $ROOT_FILENAME $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime

if [ $? -ne 0 ]; then
	echo "Error in RunGATE.sh"
	exit 1
fi

echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0
