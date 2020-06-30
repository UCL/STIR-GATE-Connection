#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z attenuation voxel size from STIR images.
## Script echo (returns) x y z variables.

ImageFilename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "ImageFilename" 1>&2
  exit 1
fi

## Get first and last edge positions
AttenuationVoxelSizes=`list_image_info $ImageFilename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2

echo $AttenuationVoxelSizes

exit 0
