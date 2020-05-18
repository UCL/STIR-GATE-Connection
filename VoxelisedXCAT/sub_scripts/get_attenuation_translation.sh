#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z attenuation translation image intetfile header.
## Script echo (returns) x y z varaibles. Needs to be unpacked.
header_filename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "header_filename" 1>&2
  exit 1
fi

## Get voxel size for x,y dimensions
voxel_sizes=`list_image_info $header_filename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2	
voxel_size_x=`echo ${voxel_sizes} |awk '{print $1}'`
voxel_size_y=`echo ${voxel_sizes} |awk '{print $2}'`

## Translation is 1/2 voxel size in x,y
translation_x=$(echo "$voxel_size_x" | awk '{print -($1/2)}')
translation_y=$(echo "$voxel_size_y" | awk '{print -($1/2)}')
translation_z=0.  ## There should not be a requirement for z translation.

## Used for return.
echo $translation_x $translation_y $translation_z
