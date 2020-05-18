#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z source position from image intetfile header.
## Returns a value to be fed as GATE parameter. This needs to be run for each x,y,z.

header_filename=$1
dimension=$2

if [ $# -ne 2 ]; then
  echo "Usage:"$0 "filename image_dimension" 1>&2
  exit 1
fi

## Get number of voxels for all dimensions
number_of_voxels=`list_image_info $header_filename| awk -F: '/Number of voxels/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2
## Get voxel sizes for all dimensions
voxel_sizes=`list_image_info $header_filename| awk -F: '/Voxel-size in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2

## Get num_voxels and voxel_size for specified dimension
case $dimension in
	x|0) ## x
		num_voxels=`echo ${number_of_voxels} |awk '{print $1}'`
		voxel_size=`echo ${voxel_sizes} |awk '{print $1}'` ;;
	y|1) ## y
		num_voxels=`echo ${number_of_voxels} |awk '{print $2}'`
		voxel_size=`echo ${voxel_sizes} |awk '{print $2}'` ;;
	z|2) ## z
		num_voxels=`echo ${number_of_voxels} |awk '{print $3}'`
		voxel_size=`echo ${voxel_sizes} |awk '{print $3}'` ;;
   *) echo "Wrong dimension '$dimension' selection. Please choose from {x,y,z}" exit 1;;
esac

## Get source position for GATE. This varies between x/y and z if x/y are odd/even
case $dimension in
	x|0|y|1) 
		if [ $((num_voxels%2)) -eq 0 ]; then  ## get EVEN x/y position
			source_position=$(echo "$num_voxels $voxel_size" | awk '{print -(($1 * $2)/2) - $2/2}')
		else ## Get ODD x/y position
			source_position=$(echo "$num_voxels $voxel_size" | awk '{print -(($1 * $2)/2)}')
		fi 
		;;
	z|1) ## Get z position
		source_position=$(echo "$num_voxels $voxel_size" | awk '{print -(($1 * $2)/2)}')	
esac

## Used for return.
echo $source_position
