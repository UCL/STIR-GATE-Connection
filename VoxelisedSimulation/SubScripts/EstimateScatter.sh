#!/usr/bin/env bash

## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2021 University College London
## Licensed under the Apache License, Version 2.0

## This script estimates the scatter on the Measured data using STIR tools.
## Built around the STIR function estimate_scatter.

## This script requires many datasets and outputs am estimation of the scatter and the additive sinogram 
## for use in STIR reconstructions. 

## The script will: 
# 	- forward project the attentuation image to get attenuation correction factors,
#	- output the multfactors (normalisation * acf for the system matrix), and
#	- then estimate the scatter using STIR's estimate_scatter code.

## If the attenuation image given is the output of GATE (it should be if computing GATE data corrections)
## then this script will flip the image in the z axis, because GATE seems to do that...

## Verbose usage:
# 	0: EstimateScatter.sh 						- Script name
# 	1: OutputFilename 							- Output filename
#	2: MeasuredData[sino_input] 				- Measured data sinogram filename
#	3: NormalisationSinogram[NormSino] 			- Normalisation sinogram filename
#	4: RandomsEstimate[randoms3d] 				- Estimated randoms filename
#	5: AttenuationImage[atnimg] 				- Attenuation image filename
# 	6: AttenuationIsGateOutput[AttenIsGATE] 	- The attenuation image the output of GATE, may be flipped in z axis
## Optional:
#	7: num_scat_iters 							- Number of scatter estimation iterations
#	8: scatter_recon_num_subiterations 			- The number of reconstruction subiterations
#	9: scatter_recon_num_subsets				- The number of reconstruction subsets

set -e # exit on error
trap "echo ERROR in $0" ERR

if [[ $# == 6 || $# == 9 ]]; then
	## Required inputs
	OutputFilename=$1
	sino_input=$2
	NORM=$3
	randoms3d=$4
	atnimg=$5
	AttenIsGATE=$6
else
	echo "Usage: ${0} OutputFilename MeasuredData[sino_input] NormalisationSinogram[NormSino] RandomsEstimate[randoms3d] AttenuationImage[atnimg] AttenuationIsGateOutput[AttenIsGATE] Optional:[num_scat_iters scatter_recon_num_subiterations scatter_recon_num_subsets]"
	echo "The final option (AttenIsGATE) is required because GATE images are inverted in z axis (no idea why...)"
	exit 1
fi

if [[ $# == 9 ]]; then
	num_scat_iters=$7
	scatter_recon_num_subiterations=$8
	scatter_recon_num_subsets=$9
else
	## Default values
	num_scat_iters=5
	scatter_recon_num_subiterations=18
	scatter_recon_num_subsets=18
fi

## SETUP: No need to change stuff here, setup for exports
acf3d=attenuation_coefficients.hs
scatter_prefix=my_scatter
total_additive_prefix=my_total_additive
mask_image=my_mask
mask_projdata_filename=my_sino_mask

## Gets the scatter par(dir) from the STIR install path (STIR examples are installed with latest versions of STIR)
STIR_install_dir=$(dirname $(dirname $(command -v estimate_scatter)))
scatter_pardir="$STIR_install_dir/share/doc/stir-5.0/examples/samples/scatter_estimation_par_files"
scatter_par="${scatter_pardir}/scatter_estimation.par"


echo "====="
echo "Beginning Scatter Estimation"

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
## Scatter sim arguments
export num_scat_iters scatter_recon_num_subiterations scatter_recon_num_subsets
## masks (debug)
export mask_projdata_filename mask_image


## Computations
echo "Compute attenuation coefficient factors"
calculate_attenuation_coefficients --ACF $acf3d $atnimg $sino_input

echo "creating multfactors"
stir_math -s --mult my_multfactors.hs $NORM $acf3d

echo "Estimate scatter time. This takes time..."
estimate_scatter ${scatter_par}

# Rename total additive sinogram to the OutputFilename
stir_math -s ${OutputFilename} "${total_additive_prefix}_${num_scat_iters}.hs"

## Optional cleanup
cleanup=1
if [ ${cleanup} == 1 ]; then
	echo "Cleaning up unneeded data!"
	rm -r extras/
	rm ${acf3d%.hs}*
	rm ${mask_image}*
	rm ${scatter_prefix}*
	rm ${mask_projdata_filename}*
	rm ${total_additive_prefix}*
else
	echo "Not performing cleanup."
fi

echo "Done with ${0}"
echo "Total additive sinogram has been saved as: ${OutputFilename}"

