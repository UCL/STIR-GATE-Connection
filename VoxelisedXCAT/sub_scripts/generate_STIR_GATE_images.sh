#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## - Script used to generate activity and attenuation images in STIR 
##   from parameter files.
## - A modification is made to the scale of the attenuation file for GATE.
## - Converts header file (.hv) to GATE compatable header (.h33) using
##   STIR2GATE_interfile.sh.
## - Copies .h33 and .v files to STIRGATEHome directory. This step is done
##   for GATE to read images.


if [ $# -ne 2 ]; then
  echo "Usage:"$0 "ActivityPar AttenuationPar" 1>&2
  echo "Returns Activity and Attenuation filenames."
  exit 0
fi

ActivityPar=$1  ## Activity parameter file
AttenuationPar=$2  ## Attenuation parameter file
STIRGATEHome=$PWD  
# cd $STIRGATEHome/images/input

## Read ActivityPar and AttenuationPar for volume filenames
ActivityFilename=`awk -F:= '/output filename/ { print $2 }' $ActivityPar`
AttenuationFilename=`awk -F:= '/output filename/ { print $2 }' $AttenuationPar`
AttenuationFilenameGATE=$AttenuationFilename"_GATE"

## Generate images
generate_image $ActivityPar
generate_image $AttenuationPar


## Modify the scale of the attenuation file for GATE (requires int values).
images/input/modifyAttenuationImageForGate.sh $AttenuationFilename".hv" $AttenuationFilenameGATE

## Process my_uniform_cylinder.hv my_atten_image_GATE.hv into .h33 files
## and add "!number of slices :=" and "slice thickness (pixels) :=" fields.
for Filename in $ActivityFilename $AttenuationFilenameGATE; do
  sh $STIRGATEHome/sub_scripts/STIR2GATE_interfile.sh $Filename".h33" $Filename".hv" 
  # cp $Filename".h33" $STIRGATEHome
  # cp $Filename".v" $STIRGATEHome
done

echo $ActivityFilename".h33" $AttenuationFilenameGATE".h33"

exit 0
