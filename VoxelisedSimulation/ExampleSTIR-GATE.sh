#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## An example of how to use this STIR-GATE-Connection project.

## This script runs `SubScripts/GenerateSTIRGATEImages.sh`
## to generate images from a parameter file using STIR.
## Additional modifications are made to the interfile header 
## for GATE compatibility.


## Job index for parallel GATE simulations
if [ $# != 1 ]
then
	echo "ExampleSTIR-GATE Usage: TASK_ID"
	exit 1
else
	TASK_ID=$1
	echo "TASK_ID = $TASK_ID"
fi


echo "Script initialised:" `date +%d.%m.%y-%H:%M:%S`

##### ==============================================================
## Activity and attenuation files
##### ==============================================================

## Generate example STIR activity and attenuation images and copy to main dir.
ActivityPar=../ExamplePhantoms/STIRparFiles/SourceSingleVoxel.par
AttenuationPar=../ExamplePhantoms/STIRparFiles/EmptyAttenuation.par

SourceFilenames=`SubScripts/GenerateSTIRGATEImages.sh $ActivityPar $AttenuationPar 2>/dev/null`
## Get activity and attenuation filenames from $SourceFilenames
ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`

##### ==============================================================
## GATE Arguments and files
##### ==============================================================

## OPTIONAL: Editable fields required by GATE macro scripts
GATEMainMacro="MainGATE.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
StartTime=0  ## Start time in GATE time
EndTime=1  ## End time in GATE time
StoreRootFilesDirectory=root_output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples (eg. D690/mMR).


## Setup Simulation. Copy files, (possibly generate phantom), and create GATE density map
./SetupSimulation.sh $ScannerType $StoreRootFilesDirectory $ActivityPar $AttenuationPar


##### ==============================================================
## RunGATE
##### ==============================================================

./RunGATE.sh $GATEMainMacro $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime


##### ==============================================================
## Unlist GATE data
##### ==============================================================

./SubScripts/UnlistRoot.sh $StoreRootFilesDirectory $TASK_ID


echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0
