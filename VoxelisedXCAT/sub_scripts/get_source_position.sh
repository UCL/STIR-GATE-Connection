#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z source position from image intetfile header.
## Script echo (returns) x y z variables.

ImageFilename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "ImageFilename" 1>&2
  exit 1
fi

## Get number of voxels for all dimensions
NumberOfVoxels=`list_image_info $ImageFilename| awk -F: '/Number of voxels/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2
NumberOfVoxelsX=`echo ${NumberOfVoxels} |awk '{print $1}'`
NumberOfVoxelsY=`echo ${NumberOfVoxels} |awk '{print $2}'`
NumberOfVoxelsZ=`echo ${NumberOfVoxels} |awk '{print $3}'`

## Get voxel sizes for all dimensions
VoxelSizes=`list_image_info $ImageFilename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2	
VoxelSizeX=`echo ${VoxelSizes} |awk '{print $1}'`
VoxelSizeY=`echo ${VoxelSizes} |awk '{print $2}'`
VoxelSizeZ=`echo ${VoxelSizes} |awk '{print $3}'`

## Get source position for GATE. This varies between x/y and z if x/y are odd/even
if [ $((NumberOfVoxelsX%2)) -eq 0 ]; then  
	## get EVEN x/y position
	SourcePositionX=$(echo "$NumberOfVoxelsX $VoxelSizeX" | awk '{print -(($1 * $2)/2) - $2/2}')
	SourcePositionY=$(echo "$NumberOfVoxelsY $VoxelSizeY" | awk '{print -(($1 * $2)/2) - $2/2}')
else 
	## Get ODD x/y position
	SourcePositionX=$(echo "$NumberOfVoxelsX $VoxelSizeX" | awk '{print -(($1 * $2)/2)}')
	SourcePositionY=$(echo "$NumberOfVoxelsY $VoxelSizeY" | awk '{print -(($1 * $2)/2)}')	
fi 
## Get z position
SourcePositionZ=$(echo "$NumberOfVoxelsZ $VoxelSizeZ" | awk '{print -(($1 * $2)/2)}')	

## Used for return.
echo $SourcePositionX $SourcePositionY $SourcePositionZ
