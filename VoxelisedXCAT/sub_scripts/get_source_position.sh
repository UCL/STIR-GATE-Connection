#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z source position from image intetfile header.
## Script echo (returns) x y z varaibles. Needs to be unpacked.
header_filename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "header_filename" 1>&2
  exit 1
fi

## Get number of voxels for all dimensions
number_of_voxels=`list_image_info $header_filename| awk -F: '/Number of voxels/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2
num_voxels_x=`echo ${number_of_voxels} |awk '{print $1}'`
num_voxels_y=`echo ${number_of_voxels} |awk '{print $2}'`
num_voxels_z=`echo ${number_of_voxels} |awk '{print $3}'`

## Get voxel sizes for all dimensions
voxel_sizes=`list_image_info $header_filename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2	
voxel_size_x=`echo ${voxel_sizes} |awk '{print $1}'`
voxel_size_y=`echo ${voxel_sizes} |awk '{print $2}'`
voxel_size_z=`echo ${voxel_sizes} |awk '{print $3}'`

## Get source position for GATE. This varies between x/y and z if x/y are odd/even
if [ $((num_voxels%2)) -eq 0 ]; then  
	## get EVEN x/y position
	source_position_x=$(echo "$num_voxels_x $voxel_size_x" | awk '{print -(($1 * $2)/2) - $2/2}')
	source_position_y=$(echo "$num_voxels_y $voxel_size_y" | awk '{print -(($1 * $2)/2) - $2/2}')
else 
	## Get ODD x/y position
	source_position_x=$(echo "$num_voxels_x $voxel_size_x" | awk '{print -(($1 * $2)/2)}')
	source_position_y=$(echo "$num_voxels_y $voxel_size_y" | awk '{print -(($1 * $2)/2)}')	
fi 
## Get z position
source_position_z=$(echo "$num_voxels_z $voxel_size_z" | awk '{print -(($1 * $2)/2)}')	

## Used for return.
echo $source_position_x $source_position_y $source_position_z
