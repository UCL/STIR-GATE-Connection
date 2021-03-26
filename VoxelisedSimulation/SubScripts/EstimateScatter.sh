#!/usr/bin/env bash

## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2021 University College London
## Licensed under the Apache License, Version 2.0

## This script estimates the scatter on the Measured data using STIR tools.
## Built around the STIR function estimate_scatter.

## This script requires many data sets and outputs a estimation of the scatter and the additive sinogram 
## for direct use in STIR reconstructions. 

## The script will: 
# 	- forward project the attentuation image to get attenuation correction factors,
#	- output the multfactors (normalisation * acf for the system matrix), and
#	- then estimate the scatter using STIR's estimate_scatter code.

## If the attenuation image given is the output of GATE (it should be if computing GATE data corrections)
## then this script will flip the image in the z axis, because GATE seems to do that...


if [[ $# != 5 ]]; then
	echo "Usage: sh ${0} sino_input NormSino randoms3d atnimg AttenIsGATE"
	echo "The final option (AttenIsGATE) is required because GATE images are inverted in z axis (no idea why...)"
	exit 1
fi

set -e # exit on error
trap "echo ERROR in $0" ERR

echo "====="
echo "Begining Scatter Estimation Script"

## Inputs
sino_input=$1
NORM=$2
randoms3d=$3
atnimg=$4
AttenIsGATE=$5

## SETUP: No need to change stuff here, setup for exports
acf3d=attenuation_coefficients.hs
scatter_prefix=my_scatter
total_additive_prefix=my_total_additive
mask_image=my_mask
mask_projdata_filename=my_sino_mask
num_scat_iters=5
scatter_recon_num_subiterations=18
scatter_recon_num_subsets=18


## This gets the example par data from the STIR install. 
STIR_install_dir=$(dirname $(dirname $(command -v estimate_scatter)))
scatter_pardir=$STIR_install_dir/share/doc/stir-5.0/examples/samples/scatter_estimation_par_files
scatter_par="${scatter_pardir}/scatter_estimation.par"

### Manipulate the attenuation map from GATE
## GATE outputs with an offset and inverted z axis, these methods correct for this
if [ $AttenIsGATE == 1 ]; then
	## Create zeros with 0 origin
	tmpImage="my_zflipped_atten.hv"
	stir_math  $tmpImage $atnimg
	## invert the z axis of $tmpImage if it is a GATE output
	invert_axis z $tmpImage $tmpImage
	## Reassign atnimg to the flipped tmpImage 
	atnimg=$tmpImage
fi

## Exports
## Outputs
export total_additive_prefix scatter_prefix
## Input data
export sino_input atnimg NORM acf3d randoms3d scatter_pardir
## Scatter sim arguements
export num_scat_iters scatter_recon_num_subiterations scatter_recon_num_subsets
## masks (debug)
export mask_projdata_filename mask_image


## Computations
echo "Compute attenuation coefficient factors"
calculate_attenuation_coefficients --PMRT --ACF $acf3d $atnimg $sino_input

echo "creating mulltfactors"
stir_math -s --mult my_multfactors.hs $NORM $acf3d

echo "Estimate scatter time. This takes time..."
estimate_scatter ${scatter_par}


## Optional cleanup
cleanup=1
if [ ${cleanup} == 1 ]; then
	echo "Cleaning up unneeded data!"
	rm -r extras/
	rm ${acf3d%.hs}*
	rm ${mask_image}*
	rm ${scatter_prefix}*
	rm ${mask_projdata_filename}*
	# Delete all ${total_additive_prefix}* files that are not the final one.
	for total_additive_file in ${total_additive_prefix}*; 
	do 
		if [[ ${total_additive_file} != *"${total_additive_prefix}_${num_scat_iters}"* ]]; 
		then
			echo "Deleting ${total_additive_file}"
			rm "${total_additive_file}"
		else
			echo "Keeping ${total_additive_file}"
		fi
	done
else
	echo "Not performing cleanup."
fi

echo "Done with ${0}"
