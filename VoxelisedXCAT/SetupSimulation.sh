#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This script should be run before any reconstruction.

# This script will:
#	- Copy files from correct scanner geometry (runs sub_scripts/prepare_scanner.sh)
#	- OPTIONAL: If ACTIVITY and ATTENUATION have "par" extension, use STIR to generate voxelised phantom
#	- Opens Gate and creates DMAP for phantom (this should only be run once per phantom.)


# {add parameter checks}
if [ $# != 4 ]
then
	echo "SetupSimulation: Setup scanner, voxelised phantom files and dmap"
	echo "Usage: ScannerType StoreRootFilesDirectory Activity(Par/Filename) Attenuation(Par/Filename)"
	exit 1
fi

# Parameters
ScannerType=$1
StoreRootFilesDirectory=$2
ACTIVITY=$3
ATTENUATION=$4


## Get the scanner files into GATESubMacros directory.
./sub_scripts/prepare_scanner_files.sh $ScannerType


# Check extension of ACTIVITY and ATTENUATION
if [ "${ACTIVITY##*.}" == "par"  ] && [ "${ATTENUATION##*.}" == "par"  ]
then
	# If "par", then generate voxelised phantom using STIR
	ACTIVITYPAR=$ACTIVITY
	ATTENUATIONPAR=$ATTENUATION
	echo "Generating voxelised phantom"
	SourceFilenames=`sub_scripts/generate_STIR_GATE_images.sh $ACTIVITYPAR $ATTENUATIONPAR 2>/dev/null`
	## Get activity and attenuation filenames from $SourceFilenames and replace
	ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
	AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`
else
	# Otherwise, then generate voxelised phantom using STIR
	ActivityFilename=$ACTIVITY
	AttenuationFilename=$ATTENUATION
fi

# Check AttenuationFilename has extension "h33"
if [ "${AttenuationFilename##*.}" != "h33"  ]
then
	echo "SetupSimulation: AttenuationFilename does not have suffix *.h33"
	echo $AttenuationFilename
	exit 1
fi

## Run a very short simulation to setup and save dmap.hdr
Gate GATESubMacros/SetupDmap.mac -a [AttenuationFilename,$AttenuationFilename]

echo "SetupSimulation Complete"
