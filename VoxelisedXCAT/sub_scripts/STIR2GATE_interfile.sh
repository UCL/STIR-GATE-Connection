#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## Script take a STIR image header filename and converts it into a GATE
## compatable .h33 file. Additionally, "!number of slices" and 
## "slice thickness (pixels)" fields are added.


if [ $# -ne 2 ]; then
  echo "Usage:"$0 "GATEOutputFilename STIRInputFilename" 1>&2
  echo " - GATEOutputFilename: should have '.h33' suffix."
  echo " - STIRInputFilename: should have '.hv' suffix"
  exit 0
fi

GATEFilename=$1
STIRFilename=$2


## Get the number of slices = Number of voxels in z
NumberOfSlices=`list_image_info $STIRFilename | awk -F: '/Number of voxels / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
## Get slice thickness in z
SliceThickness=`list_image_info $STIRFilename | awk -F: '/Voxel-size in mm / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
## Get the line number to insert the text into
LineNum=`grep -n "!END OF INTERFILE" $STIRFilename | cut -d : -f 1`

# Add $NumberOfSlices and $SliceThickness at $LineNum
# sed here adds the two line and then echos(saves) into the file $GATEFilename 
sed $LineNum'i\
!number of slices := '$NumberOfSlices'\
slice thickness (pixels) := '$SliceThickness'
' $STIRFilename > $GATEFilename

exit 0
