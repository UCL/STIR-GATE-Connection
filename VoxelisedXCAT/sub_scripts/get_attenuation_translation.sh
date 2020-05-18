#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z attenuation translation for STIR images.
## Script echo (returns) x y z variables.

ImageFilename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "ImageFilename" 1>&2
  exit 1
fi

## Get voxel size for x,y dimensions
VoxelSizes=`list_image_info $ImageFilename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2	
VoxelSizeX=`echo ${VoxelSizes} |awk '{print $1}'`
VoxelSizeY=`echo ${VoxelSizes} |awk '{print $2}'`

## Translation is 1/2 voxel size in x,y
TranslationX=$(echo "$VoxelSizeX" | awk '{print -($1/2)}')
TranslationY=$(echo "$VoxelSizeY" | awk '{print -($1/2)}')
TranslationZ=0.  ## There should not be a requirement for z translation.

## Used for return.
echo $TranslationX $TranslationY $TranslationZ
