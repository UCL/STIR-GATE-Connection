#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## An example of how to use this STIR-GATE-Connection project.

## Runs `SubScripts/GenerateSTIRGATEImages.sh` and `SetupSimulation.sh` to generate images from a parameter file using STIR and setup the GATE simulation.
## Runs `RunGATE.sh` to simulate the photon emmissions of the phantom in the specified scanner.
## Unlists the root file generated in the GATE simulation into sinograms using STIR functions.


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
## GATE Arguments and files
##### ==============================================================

## activity and attenuation files
Activity=../ExamplePhantoms/STIRparFiles/SourceSingleCentralVoxel.par
Attenuation=../ExamplePhantoms/STIRparFiles/EmptyAttenuation.par

## OPTIONAL: Editable fields required by GATE macro scripts
GATEMainMacro="MainGATE.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
StartTime=0  ## Start time in GATE time
EndTime=1  ## End time in GATE time
StoreRootFilesDirectory=Output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples (eg. D690/mMR).
ROOT_FILENAME=Sim_$TASK_ID
UnlistScatteredCoincidences=1
UnlistRandomCoincidences=1


##### ==============================================================
## Create activity and attenuation files for GATE simulation
##### ==============================================================

## This could be done in SetupSimulation.sh but we need the $ActivityFilename and 
## $AttenuationFilename for this example
SourceFilenames=`SubScripts/GenerateSTIRGATEImages.sh $Activity $Attenuation 2>/dev/null`
if [ $? -ne 0 ] ;then
	echo "Error in SubScripts/GenerateSTIRGATEImages.sh"
	echo $GenerateSTIRGATEImagesOUTPUT
	exit 1
fi
## Get activity and attenuation filenames from $SourceFilenames
ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`

## Setup Simulation. Copy files, (possibly generate phantom), and create GATE density map
./SetupSimulation.sh $ScannerType $StoreRootFilesDirectory $Activity $Attenuation
# ./SetupSimulation.sh $ScannerType $StoreRootFilesDirectory $ActivityPar $AttenuationPar
if [ $? -ne 0 ] ;then
	echo "Error in SetupSimulation.sh"
	exit 1
fi


##### ==============================================================
## RunGATE
##### ==============================================================

./RunGATE.sh $GATEMainMacro $ROOT_FILENAME $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime
if [ $? -ne 0 ]; then
	echo "Error in RunGATE.sh"
	exit 1
fi

##### ==============================================================
## Unlist GATE data
##### ==============================================================

## Unlist Coincidences, ROOT_FILENAME should be same as above, ignore "*.Coincidences.root" addition
./SubScripts/UnlistCoincidences.sh $StoreRootFilesDirectory $ROOT_FILENAME $UnlistScatteredCoincidences $UnlistRandomCoincidences 
if [ $? -ne 0 ]; then
	echo "Error in ./SubScripts/UnlistCoincidences.sh"
	exit 1
fi

echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0
