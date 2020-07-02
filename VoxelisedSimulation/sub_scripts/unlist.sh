#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

# This file will make a altered copy of "lm_to_projdata_template.par" and "root_header_template.par" before unlisting a root file into an interfile.

# The Required Args:
# - $1: Root files directory
# - $2: Task_ID
StoreRootFilesDirectory=$1
TASK_ID=$2

LowerEnergyThreshold=0
UpperEngeryThreshold=1000

echo "STIR-GATE-connection unlisting"

if [ $# -ne 2 ]; then
  echo "Usage:"$0 "StoreRootFilesDirectory TASK_ID" 1>&2
  exit 1
else
	echo "Unlisting $StoreRootFilesDirectory/ROOT_OUTPUT_$TASK_ID.root"
fi

cd $StoreRootFilesDirectory

#============= create parameter file from template =============
cp  Templates/lm_to_projdata_template.par lm_to_projdata_${TASK_ID}.par
sed -i.bak "s/TASK_ID/$TASK_ID/g" lm_to_projdata_$TASK_ID.par
sed -i.bak "s/UNLISTINGDIRECTORY/UnlistedSinograms/g" lm_to_projdata_${TASK_ID}.par


cp  Templates/root_header_template.hroot  root_header_${TASK_ID}.hroot
sed -i.bak "s/TASK_ID/${TASK_ID}/g" root_header_${TASK_ID}.hroot
sed -i.bak "s/LOWTHRES/${LowerEnergyThreshold}/g" root_header_${TASK_ID}.hroot
sed -i.bak "s/UPTHRES/${UpperEngeryThreshold}/g" root_header_${TASK_ID}.hroot

rm *.bak


lm_to_projdata lm_to_projdata_${TASK_ID}.par

