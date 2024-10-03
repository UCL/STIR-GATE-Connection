#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2021 University College London
## Licensed under the Apache License, Version 2.0


# This is a debugging script and may not be properly maintained.
# This script utilises a debug hroot file and unlists 4 different event types into 4 different sinograms via multiple unlistings.
# The event types that are unlisted are:
#   1. Unscattered from same eventID        (Trues)
#   2. Unscattered from different eventIDs  (Randoms)
#   3. Scattered from same eventID          (Scattered)
#   4. Scattered different eventIDs         (ScatteredRandoms)
# There is no overlap between the output sinograms and the summation of the sinograms equates to the unlisting of the total data, without exclusions.

# The Required Args:
# - $1: Root files directory
# - $2: ROOT_FILENAME_PREFIX
# - $3: Which data to unlist ("Coincidences" or "Delayed") 

## Optional Args:
# - $4: Acceptance Probability (range 0-1. Default:1). The probability an event is accepted to be unlisted. If 1, all events are accepted.
# - $5: Lower Energy Threshold in keV (Default: 0)
# - $6: Upper Energy Threshold in keV (Default: 1000)
# - $7: The Maximum Number of Events to Unlist into a Sinogram. (Default: -1, no limit) For this script setting this variable does not make much sense.

## Example Usgage:
# Minimum arguments for an `sh ExampleSTIR-GATE.sh 1` simulation to debug unlist the coincidences:
# - `sh ${SGCPATH}/VoxelisedSimulation/DebuggingScripts/DebugUnlistRoot.sh ${SGCPATH}/VoxelisedSimulation/Output Sim_1 Coincidences`


set -e # exit on error
trap "echo ERROR in $0" ERR

## Input arguments
StoreRootFilesDirectory=$1
ROOT_FILENAME_PREFIX=$2
EventDataType=$3
AcceptanceProb=$4
LowerEnergyThreshold=$5
UpperEngeryThreshold=$6
NumEventsToStore=$7

# Use a debug directory
UnlistingDirectory="${StoreRootFilesDirectory}/Unlisted/${EventDataType}/Debug"

echo ""
echo "STIR-GATE-Connection Debug Unlisting ROOT data script."
echo "This script will unlist a Root file 4 times. Each unlisting will unlist a different event type (no overlap)."
echo ""

## Check the number of inputs
if [ $# -lt 3 ]; then
  echo "Usage: $0 StoreRootFilesDirectory ROOT_FILENAME_PREFIX EventDataType [ AcceptanceProb(Default:1) [LowerEngeryThreshold(Default:0) UpperEngeryThreshold(Default:1000) [NumEventsToStore(Default=-1)]]]" 1>&2
  exit 1
fi
if [ $# -lt 6 ]; then
	LowerEnergyThreshold=0
	UpperEngeryThreshold=1000
fi
if [ $# -lt 7 ]; then
	NumEventsToStore=-1
fi

## Check EventDataType is Coincidences or Delayed 
if [ $EventDataType != "Coincidences" ] && [ $EventDataType != "Delayed" ]; then
	echo "Error UnlistRoot can currently only handle Coincidences and Delayed"
	exit 1
fi


## ============= Configure =============

## Ensure the UnlistingDirectory exists.
if [ ! -d $UnlistingDirectory ]; then
	echo "creating directory $UnlistingDirectory"
	mkdir -p $UnlistingDirectory  ## Made from respect of $StoreRootFilesDirectory
fi

# Get a random seed int
seed=${RANDOM}

## Rename the interpration of the ROOT file to have "*.EventDataType" in the name.
ROOT_FILENAME=$ROOT_FILENAME_PREFIX"."$EventDataType

echo "Unlisting ${StoreRootFilesDirectory}/${ROOT_FILENAME}.root"
if [ ${NumEventsToStore} != -1 ]; then
	echo "Unlisting a maximim of ${NumEventsToStore} events, it is recommended to set this to -1 (default)."
fi


## ============= Loop over EventTypes and unlist each sinogram =============
for EventType in Trues Scattered Randoms RandomScattered; do

	echo ""
	echo ""
	echo ""
	echo " ==== Processing Event Type [${EventType}] ==== "
	echo ""

	SinogramID="Sino_${EventType}_${ROOT_FILENAME}"

	echo "Output Unlisting directory: ${UnlistingDirectory}"
	echo "Output Sinogram Name: ${SinogramID}"


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

	## Edit root header template based upon ${EventType} to filter which type of events to unlist
	case "${EventType}" in
		Trues) 	
		echo "Unlisting events: Unscattered from same eventID."
		sed -i.bak "s/{EXCLUDENONRANDOM}/0/g" ${ROOT_FILENAME_PATH}  # Include non-randoms events
		sed -i.bak "s/{EXCLUDEUNSCATTERED}/0/g" ${ROOT_FILENAME_PATH}  # Include unscattered events
		sed -i.bak "s/{EXCLUDESCATTER}/1/g" ${ROOT_FILENAME_PATH}  # Exclude scattered events
		sed -i.bak "s/{EXCLUDERANDOM}/1/g" ${ROOT_FILENAME_PATH}  # Exclude randoms events
		;;
		Scattered)  
		echo "Unlisting events: Scattered from same eventID."
		sed -i.bak "s/{EXCLUDENONRANDOM}/0/g" ${ROOT_FILENAME_PATH}  # Include non-randoms events
		sed -i.bak "s/{EXCLUDEUNSCATTERED}/1/g" ${ROOT_FILENAME_PATH}  # Exclude unscattered events
		sed -i.bak "s/{EXCLUDESCATTER}/0/g" ${ROOT_FILENAME_PATH}  # Include scattered events
		sed -i.bak "s/{EXCLUDERANDOM}/1/g" ${ROOT_FILENAME_PATH}  # Exclude randoms events
    ;;
		Randoms) 
		echo "Unlisting events: Unscattered from different eventIDs."
		sed -i.bak "s/{EXCLUDENONRANDOM}/1/g" ${ROOT_FILENAME_PATH}  # Exclude non-randoms events
		sed -i.bak "s/{EXCLUDEUNSCATTERED}/0/g" ${ROOT_FILENAME_PATH}  # Include unscattered events
		sed -i.bak "s/{EXCLUDESCATTER}/1/g" ${ROOT_FILENAME_PATH}  # Exclude scattered events
		sed -i.bak "s/{EXCLUDERANDOM}/0/g" ${ROOT_FILENAME_PATH}  # Include randoms events
    ;;
		RandomScattered)		
		echo "Unlisting events: Scattered from different eventIDs."
		sed -i.bak "s/{EXCLUDENONRANDOM}/1/g" ${ROOT_FILENAME_PATH}  # Exclude non-randoms events
		sed -i.bak "s/{EXCLUDEUNSCATTERED}/1/g" ${ROOT_FILENAME_PATH}  # Exclude unscattered events
		sed -i.bak "s/{EXCLUDESCATTER}/0/g" ${ROOT_FILENAME_PATH}  # Include scattered events
		sed -i.bak "s/{EXCLUDERANDOM}/0/g" ${ROOT_FILENAME_PATH}  # Include randoms events
    ;;
		*) 
		echo "Unknown EventType, should not get here... exiting with error!"
		exit 1
	  ;;
	esac
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
	echo "Sinogram saved as ./${UnlistingDirectory}/${SinogramID}"

done # End of EventType loop
echo ""
echo "Finished DebugUnlistRoot script."
echo ""

exit 0
