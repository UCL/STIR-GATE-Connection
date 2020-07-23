#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This file will make a altered copy of "lm_to_projdata_template.par" and 
# "root_header_template.par" before unlisting a root file into an interfile.

# The Required Args:
# - $1: Root files directory
# - $2: ROOT_FILENAME (no suffix) 

## Optional Args:
# - $3: Include Scatter flag (0 or 1. Default:1)
# - $4: Include Random flag (0 or 1. Default:1)


## Input arguments
StoreRootFilesDirectory=$1
ROOT_FILENAME=$2
ScatterFlag=$3
RandomFlag=$4


UnlistingDirectory="Unlisted/UnlistedSinograms"
LowerEnergyThreshold=0
UpperEngeryThreshold=1000

echo "STIR-GATE-connection unlisting"

## Check the number of inputs
if [ $# -lt 2 ]; then
  echo "Usage:"$0 "StoreRootFilesDirectory ROOT_FILENAME (no suffix) [ IncludeScatterFlag(Default:1) IncludeRandomFlag(Default:1) ]" 1>&2
  exit 1
elif [ $# -lt 4 ]; then
	ScatterFlag=1
	RandomFlag=1
fi

## Ensure ScatterFlag and RandomFlag are 0 or 1. Set Exclude versions respectively
if [ $ScatterFlag == 0 ]; then
	ExcludeScatterFlag=1
elif [ $ScatterFlag == 1 ]; then
	ExcludeScatterFlag=0 
else
	echo "ScatterFlag needs to be 0 or 1"
	exit 1
fi 

if [ $RandomFlag -eq 0 ]; then
	ExcludeRandomFlag=1
elif [ $RandomFlag -eq 1 ]; then
	ExcludeRandomFlag=0 
else
	echo "RandomFlag needs to be 0 or 1"
	exit 1
fi 


## Rename the interpration of the ROOT file to have "*.Coincidences" in the name. Unlist the coincidence file.
ROOT_FILENAME=$ROOT_FILENAME".Coincidences"

## Name of the sinogram file ID, uses Scatter and Random Flags
SinogramID="Sino_${ROOT_FILENAME}_S${ScatterFlag}R${RandomFlag}"


## Console ouput regarding unlisting
echo "Unlisting ${StoreRootFilesDirectory}/${ROOT_FILENAME}.root"
echo "Unlisting with EXCLUDESCATTER = ${ExcludeScatterFlag}"
echo "Unlisting with EXCLUDERANDOM = ${ExcludeRandomFlag}"


cd $StoreRootFilesDirectory

#============= create parameter file from template =============
cp  Templates/lm_to_projdata_template.par lm_to_projdata_${ROOT_FILENAME}.par
sed -i.bak "s/{ROOT_FILENAME}/${ROOT_FILENAME}/g" lm_to_projdata_${ROOT_FILENAME}.par
sed -i.bak "s/{SinogramID}/${SinogramID}/g" lm_to_projdata_${ROOT_FILENAME}.par
sed -i.bak "s|{UNLISTINGDIRECTORY}|${UnlistingDirectory}|g" lm_to_projdata_${ROOT_FILENAME}.par


cp  Templates/root_header_template.hroot  ${ROOT_FILENAME}.hroot
sed -i.bak "s/{ROOT_FILENAME}/${ROOT_FILENAME}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/{LOWTHRES}/${LowerEnergyThreshold}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/{UPTHRES}/${UpperEngeryThreshold}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/{EXCLUDESCATTER}/${ExcludeScatterFlag}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/{EXCLUDERANDOM}/${ExcludeRandomFlag}/g" ${ROOT_FILENAME}.hroot
rm *.bak


## Perform Root file unlisting
lm_to_projdata lm_to_projdata_${ROOT_FILENAME}.par

## Echo sinogram filepath
echo "Sinogram saved as ./${StoreRootFilesDirectory}/Unlisted/UnlistedSinograms/${SinogramID}"

exit 0
