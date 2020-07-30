#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This script should be run before any GATE simulations.

## This script:
##	- Copies files from correct scanner geometry (runs SubScripts/PrepareScannerFiles.sh)
##	- OPTIONAL: If ACTIVITY and ATTENUATION have "par" extension, use STIR to generate voxelised phantom
##	- Opens Gate and creates DMAP for phantom (this should only be run once per phantom.)

## Several arguements are required by this script:
##  - ScannerType - A predefined scanner name in the ExampleScanner files directory.
##  - StoreRootFilesDirectory - The directory the root files will be saved.
##  - Activity - Activity file for setup. See below for more details.
##  - Attenuation - Attenuation file for setup. See below for more details.

## The activity and attenuation files to be provided can be one of two things. 
## 1: These could be a STIR parameter file for generating data. See a collection of examples in `ExamplePhantoms/STIRparFiles/`.
## 2: These could be a STIR reable voxelised phantom. 

# Usage Checks
if [ $# != 4 ]
then
	echo "SetupSimulation: This script sets up the scanner, voxelised phantom files, and dmap"
	echo "Usage: ScannerType StoreRootFilesDirectory Activity(Par/Filename) Attenuation(Par/Filename)"
	exit 1
fi

# Parameters
ScannerType=$1
StoreRootFilesDirectory=$2
ACTIVITY=$3
ATTENUATION=$4


## Get the scanner files into GATESubMacros directory.
./SubScripts/PrepareScannerFiles.sh $ScannerType $StoreRootFilesDirectory
if [ $? -ne 0 ]; then
	echo "Error in SubScripts/PrepareScannerFiles.sh"
	exit 1
fi

## Check extension of ACTIVITY and ATTENUATION.
## If they are .par of .hv, send to SubScripts/GenerateSTIRGATEImages.sh

if [ "${ACTIVITY##*.}" == "h33" -a "${ATTENUATION##*.}" == "h33" ]
then
	echo "User provided precreated .h33 files."
	## User input a .h33 file for GATE to use. We assume everything is correct here
	ActivityFilename=$ACTIVITY
	AttenuationFilename=$ATTENUATION
else
	echo "\nRunning SubScripts/GenerateSTIRGATEImages.sh on\n    $ACTIVITY $ATTENUATION"
	GenerateSTIRGATEImagesOUTPUT=`SubScripts/GenerateSTIRGATEImages.sh $ACTIVITY $ATTENUATION 2>/dev/null`
	if [ $? -ne 0 ] ;then
		echo "Error in SubScripts/GenerateSTIRGATEImages.sh"
		echo $GenerateSTIRGATEImagesOUTPUT
		exit 1
	fi
	## Get activity and attenuation filenames from $GenerateSTIRGATEImages and replace
	ActivityFilename=`echo ${GenerateSTIRGATEImagesOUTPUT} |awk '{print $1}'`
	AttenuationFilename=`echo ${GenerateSTIRGATEImagesOUTPUT} |awk '{print $2}'`
fi

# Check ActivityFilename and AttenuationFilename has extension "h33"
if [ "${ActivityFilename##*.}" != "h33"  ] || [ "${AttenuationFilename##*.}" != "h33"  ]
then
	echo "\nSetupSimulation: ActivityFilename and/or AttenuationFilename does not have suffix '*.h33'"
	echo $ActivityFilename $AttenuationFilename
	exit 1
fi


echo "Making Output Directories"
mkdir -p $StoreRootFilesDirectory/images

echo "\nSetting up GATE density map on using:"
echo "    $AttenuationFilename"
## Run a very short simulation to setup and save dmap.hdr
Gate GATESubMacros/SetupDmap.mac -a [AttenuationFilename,$AttenuationFilename][StoreRootFilesDirectory,$StoreRootFilesDirectory]

echo "\nSetupSimulation.sh Complete\n"

exit 0
