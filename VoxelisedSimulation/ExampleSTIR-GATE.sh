#!/usr/bin/env bash
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## An example of how to use this STIR-GATE-Connection project.

# Tutorial
# ===========
# New to the project? This example script will work through the basic usage. 
# This script aims to use each of the three main aspects of this project: voxelised phantom creation, GATE simulation, and unlisting of a root file.
# This script requries one argument input that is a simulation unique identifier (e.g. `./ExampleSTIR-GATE.sh "test"`). 


## Job index for parallel GATE simulations
if [ $# != 1 ]
then
	echo "ExampleSTIR-GATE Usage: TASK_ID"
	exit 1
else
	TASK_ID=$1
	echo "TASK_ID = $TASK_ID"
fi

set -e # exit on error
trap "echo ERROR in $0" ERR


echo "Script initialised:" `date +%d.%m.%y-%H:%M:%S`

##### ==============================================================
## Parameters,GATE Arguments and files
##### ==============================================================

## Activity and Attenuation files. 
## There are two main options here: 
##		1. define `.par` files, or 
##		2. provide interfile images (i.e. precreated voxelised phantoms) and as long as STIR can read them, they are usable in this project. 
Activity=../ExamplePhantoms/STIRparFiles/generate_uniform_cylinder.par
Attenuation=../ExamplePhantoms/STIRparFiles/generate_atten_cylinder.par

## OPTIONAL: Editable fields required by the GATE macro scripts
GATEMainMacro="MainGATE.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
StartTime=0  ## Start time (s) in GATE time
EndTime=1  ## End time (s) in GATE time
StoreRootFilesDirectory=Output  ## Save location of root data (default: `Output/`)
ScannerType="D690"  # Selection of scanner from Examples (eg. D690/mMR)
ROOT_FILENAME_PREFIX=Sim_$TASK_ID ## This is the output filename of the root file from GATE. We suggest the usage of the $TASK_ID variable in this naming

## Unlisting Coincidence data into sinograms
## STIR can reject certain types of events based upon event infomation.
UnlistScatteredCoincidences=1  ## Unlist Scattered photon coincidence events (0 or 1)
UnlistRandomCoincidences=1  ## Unlist Random coincidence events (0 or 1)

## Unlist Delayed coincidence event data. This can be used in randoms estimation
UnlistDelayedEvents=1


##### ==============================================================
## Create activity and attenuation files for GATE simulation
##### ==============================================================

## This could be done by SetupSimulation.sh, but we need the $ActivityFilename and 
## $AttenuationFilename for this example
SourceFilenames=`SubScripts/GenerateSTIRGATEImages.sh $Activity $Attenuation 2>/dev/null`
if [ $? -ne 0 ] ;then
	echo "Error in SubScripts/GenerateSTIRGATEImages.sh"
	echo $GenerateSTIRGATEImagesOUTPUT
	exit 1
fi
## Get activity and attenuation filenames from the output of SubScripts/GenerateSTIRGATEImages.sh
ActivityFilename=`echo $SourceFilenames | awk '{print $(NF-1)}'`
AttenuationFilename=`echo $SourceFilenames | awk '{print $NF}'`

## Setup Simulation. Copy files, (possibly generate phantom), and create GATE density map
./SetupSimulation.sh $ScannerType $StoreRootFilesDirectory $ActivityFilename $AttenuationFilename
if [ $? -ne 0 ] ;then
	echo "Error in SetupSimulation.sh"
	exit 1
fi


##### ==============================================================
## RunGATE
##### ==============================================================

## Here many arguments are given to the script ./RunGate.sh 
## This script does computation to center the voxelised phantom on the origin (center of scanner).
## This script will also handle a lot of the GATE macro variables.
./RunGATE.sh $GATEMainMacro $ROOT_FILENAME_PREFIX $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime
if [ $? -ne 0 ]; then
	echo "Error in RunGATE.sh"
	exit 1
fi


##### ==============================================================
## Unlist GATE data
##### ==============================================================

## Unlist Coincidences, ROOT_FILENAME_PREFIX should be same as above, ignore "*.Coincidences.root" addition
./SubScripts/UnlistRoot.sh $StoreRootFilesDirectory $ROOT_FILENAME_PREFIX "Coincidences" $UnlistScatteredCoincidences $UnlistRandomCoincidences 
if [ $? -ne 0 ]; then
	echo "Error in ./SubScripts/UnlistRoot.sh for Coincidences"
	exit 1
fi

if [ $UnlistDelayedEvents == 1 ]; then
	## Unlist Delayed, ROOT_FILENAME_PREFIX should be same as above, ignore "*.Delayed.root" addition
	./SubScripts/UnlistRoot.sh $StoreRootFilesDirectory $ROOT_FILENAME_PREFIX "Delayed" $UnlistScatteredCoincidences $UnlistRandomCoincidences 
	if [ $? -ne 0 ]; then
		echo "Error in ./SubScripts/UnlistRoot.sh for Delayed."
		echo "Sometimes with the Example single voxel this can happen becasue there are no Delayed events."
	fi
else 
	echo "Unlisting of Delayed events has been disabled by [UnlistDelayedEvents = ${UnlistDelayedEvents}]."
fi

echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0
