#! /bin/sh

## AUTHOR: ROBERT TWYMAN
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## Script to run GATE a similation given various arguments. 
## The script calls scripts to compute SourcePosition, 
## AttenuationTranslation, AtteniationVoxelSize, 
## and NumberOfVoxels (attenuation file).

if [ $# != 8 ] && [ $# !=9 ]; then
  echo "Error in $0 with number of arguments."
  echo "Usage: $0 GATEMainMacro ROOT_FILENAME_PREFIX ActivityFilename AttenuationFilename SimuId StartTime EndTime [QT]" 1>&2
  exit 1
fi

set -e # exit on error
trap "echo ERROR in $0" ERR

# Parameters for GATE
GATEMainMacro=$1
ROOT_FILENAME_PREFIX=$2
ActivityFilename=$3
AttenuationFilename=$4
StoreRootFilesDirectory=$5
TASK_ID=$6
StartTime=$7
EndTime=$8

## Optional QT visualisation, required seperate GATE setup
QT=0
if [ $# == 9 ] && [ $9 == "1" ]
then 
	echo "Gate --qt is ON"
	QT=1 
fi

## Compute the length of 1 of NumSlices TimeSlice(s) for GATE simulation
NumSlices=10
TimeSlice="$(echo $StartTime $EndTime $NumSlices | awk '{ tmp=($2 - $1)/($3) ; printf"%0.10f", tmp }')"

## Get the activity source position in x,y,z
SourcePositions=$( SubScripts/GetSourcePosition.sh $ActivityFilename 2>/dev/null ) 
SourcePositionX=`echo ${SourcePositions} |awk '{print $1}'`
SourcePositionY=`echo ${SourcePositions} |awk '{print $2}'`
SourcePositionZ=`echo ${SourcePositions} |awk '{print $3}'`
if [ $? -ne 0 ]; then
	echo "Error in SubScripts/GetSourcePosition.sh"
	exit 1
fi


## Get the attenuation map translation in x,y,z
AttenuationTranslations=$( SubScripts/GetAttenuationTranslation.sh $AttenuationFilename 2>/dev/null ) 
AttenuationTranslationX=`echo ${AttenuationTranslations} |awk '{print $1}'`
AttenuationTranslationY=`echo ${AttenuationTranslations} |awk '{print $2}'`
AttenuationTranslationZ=`echo ${AttenuationTranslations} |awk '{print $3}'`
if [ $? -ne 0 ]; then
	echo "Error in SubScripts/GetAttenuationTranslation.sh"
	exit 1
fi


## Get the voxel size in x,y,z (stir_print_voxel_sizes.sh is found: $STIRINSTALLPATH/bin/stir_print_voxel_sizes.sh)
AttenuationVoxelSize=$( stir_print_voxel_sizes.sh $AttenuationFilename 2>/dev/null ) 
## stir_print_voxel_sizes returns z,y,x, these are revesered here
AttenuationVoxelSizeX=`echo ${AttenuationVoxelSize} |awk '{print $3}'`
AttenuationVoxelSizeY=`echo ${AttenuationVoxelSize} |awk '{print $2}'`
AttenuationVoxelSizeZ=`echo ${AttenuationVoxelSize} |awk '{print $1}'`
if [ $? -ne 0 ]; then
	echo "Error in stir_print_voxel_sizes.sh"
	exit 1
fi


## Get the number of voxels in x,y,z (get_num_voxels.sh is found: $STIRINSTALLPATH/bin/get_num_voxels.sh)
NumberOfVoxels=$( get_num_voxels.sh $AttenuationFilename 2>/dev/null ) 
NumberOfVoxelsX=`echo ${NumberOfVoxels} |awk '{print $1}'`
NumberOfVoxelsY=`echo ${NumberOfVoxels} |awk '{print $2}'`
NumberOfVoxelsZ=`echo ${NumberOfVoxels} |awk '{print $3}'`
if [ $? -ne 0 ]; then
	echo "Error in get_num_voxels.sh"
	exit 1
fi


## Run GATE with arguments
if [ $QT -eq 1 ]; then

	echo "Running Gate with visualisation."
	Gate --qt $GATEMainMacro -a \
[SimuId,$TASK_ID][ROOT_FILENAME_PREFIX,$ROOT_FILENAME_PREFIX]\
[StartTime,$StartTime][EndTime,$EndTime][TimeSlice,$TimeSlice]\
[StoreRootFilesDirectory,$StoreRootFilesDirectory]\
[NumberOfVoxelsX,$NumberOfVoxelsX][NumberOfVoxelsY,$NumberOfVoxelsY][NumberOfVoxelsZ,$NumberOfVoxelsZ]\
[ActivityFilename,$ActivityFilename][AttenuationFilename,$AttenuationFilename]\
[SourcePositionX,$SourcePositionX][SourcePositionY,$SourcePositionY][SourcePositionZ,$SourcePositionZ]\
[AttenuationTranslationX,$AttenuationTranslationX][AttenuationTranslationY,$AttenuationTranslationY][AttenuationTranslationZ,$AttenuationTranslationZ]\
[AttenuationVoxelSizeX,$AttenuationVoxelSizeX][AttenuationVoxelSizeY,$AttenuationVoxelSizeY][AttenuationVoxelSizeZ,$AttenuationVoxelSizeZ]

else

	echo "Running Gate."
	Gate $GATEMainMacro -a \
[SimuId,$TASK_ID][ROOT_FILENAME_PREFIX,$ROOT_FILENAME_PREFIX]\
[StartTime,$StartTime][EndTime,$EndTime][TimeSlice,$TimeSlice]\
[StoreRootFilesDirectory,$StoreRootFilesDirectory]\
[NumberOfVoxelsX,$NumberOfVoxelsX][NumberOfVoxelsY,$NumberOfVoxelsY][NumberOfVoxelsZ,$NumberOfVoxelsZ]\
[ActivityFilename,$ActivityFilename][AttenuationFilename,$AttenuationFilename]\
[SourcePositionX,$SourcePositionX][SourcePositionY,$SourcePositionY][SourcePositionZ,$SourcePositionZ]\
[AttenuationTranslationX,$AttenuationTranslationX][AttenuationTranslationY,$AttenuationTranslationY][AttenuationTranslationZ,$AttenuationTranslationZ]\
[AttenuationVoxelSizeX,$AttenuationVoxelSizeX][AttenuationVoxelSizeY,$AttenuationVoxelSizeY][AttenuationVoxelSizeZ,$AttenuationVoxelSizeZ]

fi
