#! /bin/sh
## AUTHOR: Ludovica Brusaferri
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## This script is used to sum sinograms or images using STIR, into an output file
## Example: sh SubScripts/CombineData.sh output_sino.hs sinogram_Sim_*.hs

## This script assumes all files are all the same type and size. 

if [ $# -lt 2 ]; then
	echo "This script is used to sum sinograms or images using STIR."
	echo "Usage: SumData.sh output_filename [sinogram images]"
	exit 1
fi

output_filename=$1

for file in "$@"; do
	if [ $file == $output_filename ]; then
		## Check existance output_filename
		if [ -f $output_filename ]; then
			rm $output_filename ## Delete old copy
		fi
		# No further processing with $output_filename directly
		continue
	fi

	if [ ! -f $output_filename ]; then
		# First input file create an equal copy of itself as $output_filename
		echo "\nCreating $output_filename from $file"
		if [ "${file##*.}" = "hs" ]; then
			# Sinogram 
    		stir_math -s --times-scalar 1. $output_filename $file
			continue
		elif [ "${file##*.}" = "hv" ]; then
			# Image
    		stir_math --times-scalar 1. $output_filename $file
			continue
		fi
	fi

    if [ "${file##*.}" = "hs" ]; then
		# Combine sinograms	
    	echo "Adding $file to $output_filename"
    	stir_math -s --accumulate $output_filename $file
    	continue
    fi
	
    if [ "${file##*.}" = "hv" ]; then
    	# Combine images
    	echo "Adding $file to $output_filename"
    	stir_math --accumulate $output_filename $file
    	continue
    fi
done

echo "SumData.sh Complete."
