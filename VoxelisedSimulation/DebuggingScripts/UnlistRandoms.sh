#! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## Script it used to unlist only random events in list mode file. 
## Unlists twice, once with all events and once again with all events except randoms.
## Uses stir_math to subtract one unlisted sinogram from another resulting in a sinogram containing only random events.

# The Required Args:
# - $1: OutputFilenamePrefix
# - $2: Root files directory
# - $3: ROOT_FILENAME_PREFIX (no suffix) 

## Please note, this files is not actively maintained and is used for development.

## Input arguments

if [ $# != 3 ]; then
	echo "Usage: UnlistRandoms.sh OutputFilenamePrefix StoreRootFilesDirectory ROOT_FILENAME_PREFIX"
	exit 1
fi 

OutputFilenamePrefix=$1
StoreRootFilesDirectory=$2
ROOT_FILENAME_PREFIX=$3


## Unlist with all Trues, Scatter, Randoms
./SubScripts/UnlistRoot.sh $StoreRootFilesDirectory $ROOT_FILENAME_PREFIX 1 1

## Unlist with all Trues, Scatter
./SubScripts/UnlistRoot.sh $StoreRootFilesDirectory $ROOT_FILENAME_PREFIX 1 0



## Subtract all from all(-randoms)
echo "Subtracting all events from all events (minus Randoms)."
stir_math -s --including-first --times-scalar -1 tmp_neg ${StoreRootFilesDirectory}/Unlisted/UnlistedSinograms/Sino_${ROOT_FILENAME_PREFIX}_S1R0_f1g1d0b0.hs
stir_math -s --including-first --add ${OutputFilenamePrefix} ${StoreRootFilesDirectory}/Unlisted/UnlistedSinograms/Sino_${ROOT_FILENAME_PREFIX}_S1R1_f1g1d0b0.hs tmp_neg.hs
echo "Saved sinogram as ${OutputFilenamePrefix}.hs"
## Cleanups
rm tmp_neg.hs
rm tmp_neg.s

# list_projdata_info --all ${OutputFilenamePrefix}".hs"
exit 0
