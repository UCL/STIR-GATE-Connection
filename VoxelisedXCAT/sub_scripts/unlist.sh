#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This file will make a altered copy of "lm_to_projdata_template.par" and "root_header_template.par" before unlisting a root file into an interfile.

# The Required Args:
# - $1: Root files directory
# - $2: Root filename prefix
# - $3: Task_ID
StoreRootFilesDirectory=$1
RootFilename=$2
SGE_TASK_ID=$3

LowerEnergyThreshold=0
UpperEngeryThreshold=1000

if [ $# -ne 3 ]; then
  echo "Usage:"$0 "StoreRootFilesDirectory RootFilename SGE_TASK_ID" 1>&2
  exit 1
fi

cd $StoreRootFilesDirectory

#============= create parameter file from template =============
cp  Templates/lm_to_projdata_template.par lm_to_projdata_${SGE_TASK_ID}.par
sed -i "" "s/SGE_TASK_ID/$SGE_TASK_ID/g" lm_to_projdata_$SGE_TASK_ID.par
sed -i "" "s/UNLISTINGDIRECTORY/UnlistedSinograms/g" lm_to_projdata_${SGE_TASK_ID}.par


cp  Templates/root_header_template.hroot  root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/SGE_TASK_ID/${SGE_TASK_ID}/g" root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/LOWTHRES/${LowerEnergyThreshold}/g" root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/UPTHRES/${UpperEngeryThreshold}/g" root_header_${SGE_TASK_ID}.hroot

lm_to_projdata lm_to_projdata_${SGE_TASK_ID}.par

