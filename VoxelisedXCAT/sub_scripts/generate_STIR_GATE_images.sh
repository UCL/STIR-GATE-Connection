#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## - Script used to generate activity and attenuation images in STIR 
##   from parameter files.
## - A modification is made to the scale of the attenuation file for GATE.
## - The script copies the .hv files as .h33 (for GATE) and populates 
##   NumberOfSlices and SliceThickness in the file.
## - Copies .h33 and .v files to STIRGATEHome directory. This step is done
##   for GATE to read images.


if [ $# -ne 2 ]; then
  echo "Usage:"$0 "ActivityPar AttenuationPar" 1>&2
  exit 0
fi

ActivityPar=$1
AttenuationPar=$2
STIRGATEHome=$PWD
cd $STIRGATEHome/images/input/generate_STIR_images 

## Read ActivityPar and AttenuationPar for volume filenames
ActivityFilename=`awk -F:= '/output filename/ { print $2 }' $ActivityPar`
AttenuationFilename=`awk -F:= '/output filename/ { print $2 }' $AttenuationPar`
AttenuationFilenameGATE=$AttenuationFilename"_GATE"

## Modify the scale of the attenuation file for GATE (requires int values).
../modifyAttenuationImageForGate.sh $AttenuationFilename".hv" $AttenuationFilenameGATE

## Process my_uniform_cylinder.hv my_atten_image_GATE.hv into .h33 files
## and add "!number of slices :=" and "slice thickness (pixels) :=" fields.
for Filename in $ActivityFilename $AttenuationFilenameGATE; do
  cp $Filename".hv" $Filename".h33"

  ## Get the number of slices = Number of voxels in z
  NumberOfSlices=`list_image_info $Filename".h33" | awk -F: '/Number of voxels / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
  ## Get slice thickness in z
  SliceThickness=`list_image_info $Filename".h33" | awk -F: '/Voxel-size in mm / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
  ## Get the line number to insert the text into
  LineNum=$( grep -n "!END OF INTERFILE" $Filename".h33" | cut -d : -f 1 )

  # Add $NumberOfSlices and $SliceThickness at $LineNum
  sed -i '' $LineNum'i\
  !number of slices := '$NumberOfSlices'\
  slice thickness (pixels) := '$SliceThickness'
  ' $Filename".h33"

  ## Copy the files to the main directory.
  cp $Filename".h33" $STIRGATEHome
  cp $Filename".v" $STIRGATEHome

done

echo $ActivityFilename".h33" $AttenuationFilenameGATE".h33"

exit 0
