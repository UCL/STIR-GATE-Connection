#!/usr/bin/env bash
## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2020-2022 University College London
## Licensed under the Apache License, Version 2.0


## This script is used to generate STIR-GATE activity and attenuation images.
## Any STIR readable voxelised phantoms (activity and attenuation files) are processed into a GATE readable file formates (.h33) for simulation.
## If parameter files for generating new images using STIR are provided, these will be generated.
## A modification is made to the scale of the attenuation file. GATE requires integer attenuation factors. This script copies the phantoms and performs STIR math to increase the attenuation factors.

if [ $# -ne 2 ]; then
  echo "Usage:"$0 "Activity(.par/.hv) AttenuationPar(.par/.hv)" 1>&2
  echo "Returns Activity and Attenuation filenames." 1>&2
  exit 1
fi

set -e # exit on error
trap "echo ERROR in $0" ERR

Activity=$1  ## Activity parameter file
Attenuation=$2  ## Attenuation parameter file
STIRGATEHome=$PWD  

if [ ! -r "$Activity" ]; then
    echo "Error opening activity file $Activity" 2>&1
    exit 1
fi
if [ ! -r "$Attenuation" ]; then
    echo "Error opening attenuation file $Attenuation" 2>&1
    exit 1
fi

# test if Activity input is a par file containing "generate_image", in that case, run generate_image
if grep -q -i 'generate_image *parameters' $Activity
then
	ActivityFilename=$(awk -F:= '/output filename/ { print $2 }' $Activity)".hv"
	generate_image $Activity 

else
	# Set filename
	ActivityFilename=$Activity
fi
# same for attenuation
if grep -q -i 'generate_image *parameters' $Attenuation
then
	AttenuationFilename=$(awk -F:= '/output filename/ { print $2 }' $Attenuation)".hv"
	generate_image $Attenuation

else
	# Set filename
	AttenuationFilename=$Attenuation
fi

## Create a new copy of the image, this is to ensure the file format is consistant when going into GATE
ActivityFilenamePrefix="${ActivityFilename%%.*}"
AttenuationFilenamePrefix="${AttenuationFilename%%.*}"
ActivityFilenameGATE=$ActivityFilenamePrefix"_GATE"
AttenuationFilenameGATE=$AttenuationFilenamePrefix"_GATE"
stir_math --including-first --times-scalar 1 $ActivityFilenameGATE".hv" $ActivityFilename
## Modify the scale of the attenuation file for GATE (requires int values).
stir_math --including-first --times-scalar 10000 $AttenuationFilenameGATE".hv" $AttenuationFilename

## Process file into .h33 files.
## This adds fields: "!number of slices :=" and "slice thickness (pixels) :=".
bash ./SubScripts/STIR2GATE_interfile.sh $ActivityFilenameGATE".h33" $ActivityFilenameGATE".hv"
bash ./SubScripts/STIR2GATE_interfile.sh $AttenuationFilenameGATE".h33" $AttenuationFilenameGATE".hv"

echo $ActivityFilenameGATE".h33" $AttenuationFilenameGATE".h33"

exit 0
