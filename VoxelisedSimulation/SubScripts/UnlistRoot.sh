#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This file will make a altered copy of "lm_to_projdata_template.par" and 
# "root_header_template.par" before unlisting a root file into an interfile.

# The Required Args:
# - $1: Root files directory
# - $2: Task_ID
StoreRootFilesDirectory=$1
ROOT_FILENAME=$2

LowerEnergyThreshold=0
UpperEngeryThreshold=1000

echo "STIR-GATE-connection unlisting"

if [ $# -ne 2 ]; then
  echo "Usage:"$0 "StoreRootFilesDirectory ROOT_FILENAME" 1>&2
  exit 1
else
	echo "Unlisting ${StoreRootFilesDirectory}/${ROOT_FILENAME}.root"
fi

cd $StoreRootFilesDirectory

#============= create parameter file from template =============
cp  Templates/lm_to_projdata_template.par lm_to_projdata_${ROOT_FILENAME}.par
sed -i.bak "s/ROOT_FILENAME/${ROOT_FILENAME}/g" lm_to_projdata_${ROOT_FILENAME}.par
sed -i.bak "s/UNLISTINGDIRECTORY/UnlistedSinograms/g" lm_to_projdata_${ROOT_FILENAME}.par


cp  Templates/root_header_template.hroot  ${ROOT_FILENAME}.hroot
sed -i.bak "s/ROOT_FILENAME/${ROOT_FILENAME}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/LOWTHRES/${LowerEnergyThreshold}/g" ${ROOT_FILENAME}.hroot
sed -i.bak "s/UPTHRES/${UpperEngeryThreshold}/g" ${ROOT_FILENAME}.hroot

rm *.bak


lm_to_projdata lm_to_projdata_${ROOT_FILENAME}.par

exit 0
