## #! /bin/sh
## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2020, 2021 University College London
## Licensed under the Apache License, Version 2.0

## This script estimates the background randoms from Delayed coincidences projection data.

set -e # exit on error
trap "echo ERROR in $0" ERR

if [ $# != 2 ]; then
	echo "Usage: EstimateGATESTIRNorm.sh OutputFilename DelayedData"
	exit 1
fi 

## PARAMETERS
OutputFilename=$1 
DelayedData=$2 ## INPUT: Delayed coincidences sinogram

## factors are a temporary file created by find_ML_singles_from_delayed [deleted by cleanup]
factors=singles_from_delayed
num_iterations=10

echo "find_ML_singles_from_delayed"
find_ML_singles_from_delayed ${factors} ${DelayedData} ${num_iterations} < /dev/null

echo "construct_randoms_from_singles"
construct_randoms_from_singles ${OutputFilename} ${factors} ${DelayedData} ${num_iterations}

cleanup=1
if [ $cleanup == 1 ]; then
	rm "fansums_for_"*
	rm ${factors}"_"*
fi

echo "Estimated Randoms sinogram and saved as:" ${OutputFilename}
