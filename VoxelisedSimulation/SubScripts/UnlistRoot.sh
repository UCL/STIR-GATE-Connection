#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020, 2021 University College London
## Licensed under the Apache License, Version 2.0

# This file will make a altered copy of "lm_to_projdata_template.par" and 
# "root_header_template.par" before unlisting a root file into an interfile.

# The Required Args:
# - $1: Root files directory
# - $2: ROOT_FILENAME_PREFIX
# - $3: Which data to unlist ("Coincidences" or "Delayed") 

## Optional Args:
# - $4: Include Scatter flag (0 or 1. Default:1)
# - $5: Include Random flag (0 or 1. Default:1)
# - $6: Acceptance Probability (range 0-1. Default:1). The probability an event is accepted to be unlisted. If 1, all events are accepted.
# - $7: Lower Energy Threshold in keV (Default: 0)
# - $8: Upper Energy Threshold in keV (Default: 1000)
# - $9: The Maximum Number of Events to Unlist into a Sinogram. (Default: -1, no limit)


set -e # exit on error
trap "echo ERROR in $0" ERR

## Input arguments
StoreRootFilesDirectory=$1
ROOT_FILENAME_PREFIX=$2
EventDataType=$3
ScatterFlag=$4
RandomFlag=$5
AcceptanceProb=$6
LowerEnergyThreshold=$7
UpperEngeryThreshold=$8
NumEventsToStore=$9


UnlistingDirectory="${StoreRootFilesDirectory}/Unlisted/${EventDataType}"

echo ""
echo "STIR-GATE-Connection Unlisting ROOT data script"

## Check the number of inputs
if [ $# -lt 3 ]; then
  echo "Usage: $0 StoreRootFilesDirectory ROOT_FILENAME_PREFIX EventDataType [ IncludeScatterFlag(Default:1) IncludeRandomFlag(Default:1) [AcceptanceProb(Default:1) [LowerEngeryThreshold(Default:0) UpperEngeryThreshold(Default:1000) [NumEventsToStore(Default=-1)]]]]" 1>&2
  exit 1
fi
if [ $# -lt 5 ]; then
	ScatterFlag=1
	RandomFlag=1
fi
if [ $# -lt 8 ]; then
	LowerEnergyThreshold=0
	UpperEngeryThreshold=1000
fi
if [ $# -lt 9 ]; then
	NumEventsToStore=-1
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

## Check EventDataType is Coincidences or Delayed 
if [ $EventDataType != "Coincidences" ] && [ $EventDataType != "Delayed" ]; then
	echo "Error UnlistRoot can currently only handle Coincidences and Delayed"
	exit 1
fi

# Get a random seed int
seed=${RANDOM}

## Rename the interpration of the ROOT file to have "*.EventDataType" in the name.
ROOT_FILENAME=$ROOT_FILENAME_PREFIX"."$EventDataType

## Name of the sinogram file ID, uses Scatter and Random Flags
SinogramID="Sino_${ROOT_FILENAME}_S${ScatterFlag}R${RandomFlag}"

## ============= Console ouput regarding unlisting configuration =============

echo "Unlisting ${StoreRootFilesDirectory}/${ROOT_FILENAME}.root"
echo "Unlisting with EXCLUDESCATTER = ${ExcludeScatterFlag}"
echo "Unlisting with EXCLUDERANDOM = ${ExcludeRandomFlag}"
if [ ${NumEventsToStore} != -1 ]; then
	echo "Unlisting a maximim of ${NumEventsToStore} events."
fi


## Ensure the UnlistingDirectory exists.
if [ ! -d $UnlistingDirectory ]; then
	echo "creating directory $UnlistingDirectory"
	mkdir -p $UnlistingDirectory  ## Made from respect of $StoreRootFilesDirectory
fi


## ============= Create parameter file from template =============

## lm_to_projdata parameter file from template
LM_TO_PROJDATA_PAR_PATH=$StoreRootFilesDirectory/lm_to_projdata_${ROOT_FILENAME}.par
cp  UnlistingTemplates/lm_to_projdata_template.par ${LM_TO_PROJDATA_PAR_PATH}
sed -i.bak "s|{ROOT_FILENAME}|$StoreRootFilesDirectory/${ROOT_FILENAME}|g" ${LM_TO_PROJDATA_PAR_PATH}
sed -i.bak "s/{SinogramID}/${SinogramID}/g" ${LM_TO_PROJDATA_PAR_PATH}
sed -i.bak "s|{UNLISTINGDIRECTORY}|${UnlistingDirectory}|g" ${LM_TO_PROJDATA_PAR_PATH}
sed -i.bak "s|{seed}|${seed}|g" ${LM_TO_PROJDATA_PAR_PATH}
sed -i.bak "s|{NumEventsToStore}|${NumEventsToStore}|g" ${LM_TO_PROJDATA_PAR_PATH}

## ROOT header file from template (from scanner configuration)
ROOT_FILENAME_PATH="${StoreRootFilesDirectory}/${ROOT_FILENAME}.hroot"
cp  UnlistingTemplates/root_header_template.hroot ${ROOT_FILENAME_PATH}
sed -i.bak "s/{ROOT_FILENAME}/${ROOT_FILENAME}/g" ${ROOT_FILENAME_PATH}
sed -i.bak "s/{LOWTHRES}/${LowerEnergyThreshold}/g" ${ROOT_FILENAME_PATH}
sed -i.bak "s/{UPTHRES}/${UpperEngeryThreshold}/g" ${ROOT_FILENAME_PATH}
sed -i.bak "s/{EXCLUDESCATTER}/${ExcludeScatterFlag}/g" ${ROOT_FILENAME_PATH}
sed -i.bak "s/{EXCLUDERANDOM}/${ExcludeRandomFlag}/g" ${ROOT_FILENAME_PATH}
sed -i.bak "s/{EXCLUDENONRANDOM}/0/g" ${ROOT_FILENAME_PATH}  	# Hardcoded to include non-random events
sed -i.bak "s/{EXCLUDEUNSCATTERED}/0/g" ${ROOT_FILENAME_PATH} # Hardcoded to include unscattered events

## Remove sed temporary files
rm $StoreRootFilesDirectory/*.bak


## ============= Perform ROOT file unlisting =============

if [[ -z ${AcceptanceProb} || ${AcceptanceProb} == 1 ]]; then
	echo "No AcceptanceProb given, unlist all using standard to lm_to_projdata"
	lm_to_projdata ${LM_TO_PROJDATA_PAR_PATH}
	if [ $? -ne 0 ]; then
		echo "Error in ./SubScripts/UnlistRoot.sh: lm_to_projdata failed, see error."
		exit 1
	fi
else
	echo "AcceptanceProb = ${AcceptanceProb}, unlisting with random rejection"
	lm_to_projdata_with_random_rejection ${LM_TO_PROJDATA_PAR_PATH} ${AcceptanceProb}
	if [ $? -ne 0 ]; then
		echo "Error in ./SubScripts/UnlistRoot.sh: lm_to_projdata_with_random_rejection failed, see error."
		exit 1
	fi
fi

## Echo sinogram filepath
echo "Sinogram saved as ./${StoreRootFilesDirectory}/Unlisted/UnlistedSinograms/${SinogramID}"

exit 0
