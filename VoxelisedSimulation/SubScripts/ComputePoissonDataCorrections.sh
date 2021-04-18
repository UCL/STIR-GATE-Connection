#!/usr/bin/env bash

## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2020, 2021 University College London
## Licensed under the Apache License, Version 2.0

## This script computes the data correction terms for PET reconstruction from the measured data output by GATE simulations.
## Many datasets are required and the two outputs are: an additive sinogram and multiplication(mult)factors sinogram. 

## The script will: 
#	- estimate the contribution background due to random events from a delayed coincidence window sinogram
# 	- forward project the attentuation image to get attenuation correction factors (acf),
#	- estimate the scatter using STIR's estimate_scatter code,
#	- save the multiplicative factors (normalisation * acf for the system matrix), and
#	- save the total additive sinogram (randoms and scatter estimations).

## N.B. If the attenuation image given is the output of GATE (it should be if computing GATE data corrections)
#  then this script will flip the image in the z axis, because GATE seems to do that...

## Verbose usage:
# 	0:  EstimateScatter.sh 						- Script name
#	1:  OutputMultiplicativeFactorsFilename		- Output filename of the multiplicative factors
# 	2:  OutputAdditiveSinogramFilename			- Output filename of the additive sinogram
#	3:  CoincidenceData[sino_input]				- Coincidence data sinogram filename
#	4:  DelayedData								- Delayed coincidence data singoram filename
#	5:  NormalisationSinogram[NORM]				- Normalisation sinogram filename
#	6:  AttenuationImage[atnimg]				- Attenuation image filename
# 	7:  AttenuationIsGateOutput[AttenIsGATE]	- Is attenuation image the output of GATE, may be flipped in z axis [0 or 1]
## Optional (estimate scatter related):
#	8:  num_scat_iters							- Number of scatter estimation iterations [Default: 5]
#	9:  scatter_recon_num_subiterations			- The number of reconstruction subiterations [Default: 18]
#	10: scatter_recon_num_subsets				- The number of reconstruction subsets [Default: 18]

set -e # exit on error
trap "echo ERROR in $0" ERR

if [[ $# == 7 || $# == 10 ]]; then
	## Required arguments
	#  Output filename
	OutputMultiplicativeFactorsFilename=$1
	OutputAdditiveSinogramFilename=$2
	# Input filenames
	sino_input=$3
	DelayedData=$4
	NORM=$5
	atnimg=$6
	AttenIsGATE=$7
else
	echo "Usage: ${0} OutputMultiplicativeFactorsFilename OutputAdditiveSinogramFilename MeasuredData[sino_input] DelayedData NormalisationSinogram[NormSino] AttenuationImage[atnimg] AttenuationIsGateOutput[AttenIsGATE] Optional:[num_scat_iters scatter_recon_num_subiterations scatter_recon_num_subsets]"
	echo "The final option (AttenIsGATE) is required because GATE images are inverted in z axis (no idea why...)"
	exit 1
fi

if [[ $# == 10 ]]; then
	num_scat_iters=$8
	scatter_recon_num_subiterations=$9
	scatter_recon_num_subsets=${10}
else
	## Default values
	echo "Setting optional arguments to default"
	num_scat_iters=5
	scatter_recon_num_subiterations=18
	scatter_recon_num_subsets=18
fi


## Echo the script arguments for debugging
echo "  =========================  "
echo "Compute Poisson Data Correction script will use the following configuration:"
echo "    OutputMultiplicativeFactorsFilename = ${OutputMultiplicativeFactorsFilename}"
echo "    OutputAdditiveSinogramFilename = ${OutputAdditiveSinogramFilename}"
echo "    CoincidenceData[sino_input] = ${sino_input}"
echo "    DelayedData = ${DelayedData}"
echo "    NormalisationSinogram[NORM] = ${NORM}"
echo "    AttenuationImage[atnimg] = ${atnimg}"
echo "    AttenuationIsGateOutput[AttenIsGATE] = ${AttenIsGATE}"
echo "Optional variables:"
echo "    num_scat_iters = ${num_scat_iters}"
echo "    scatter_recon_num_subiterations = ${scatter_recon_num_subiterations}"
echo "    scatter_recon_num_subsets = ${scatter_recon_num_subsets}"
echo "  =========================  "


## SETUP of variables: No need to change stuff here, setup for exports and files will be deleted with cleanup
acf3d=my_attenuation_coefficients.hs
scatter_prefix=my_scatter
total_additive_prefix=my_total_additive
mask_image=my_mask
mask_projdata_filename=my_sino_mask
randoms3d_prefix=my_randoms
randoms3d=${randoms3d_prefix}.hs
cleanup=1 ## At the end of the script delete all files except $OutputAdditiveSinogramFilename and $multfactors

## Gets the scatter par(dir) from the STIR install path (STIR examples are installed with latest versions of STIR)
STIR_install_dir=$(dirname $(dirname $(command -v estimate_scatter)))
scatter_pardir="$STIR_install_dir/share/doc/stir-5.0/examples/samples/scatter_estimation_par_files"
scatter_par="${scatter_pardir}/scatter_estimation.par"

## Get the SGC_Home
SGC_SubScripts=$(dirname ${0})

## Estimate the randoms from delays
echo "====="
echo "Computing contribution due to randoms from DelayedData"
sh ${SGC_SubScripts}/EstimateRandomsFromDelayed.sh ${randoms3d} ${DelayedData}


echo "====="
echo "Beginning Scatter Estimation"

### Manipulate the attenuation map from GATE
## GATE outputs with an offset and inverted z axis, these methods correct for this
if [ $AttenIsGATE == 1 ]; then
	## invert the z axis of $tmpImage if it is a GATE output
	tmpImage="my_zflipped_atten.hv"	
	invert_axis z $tmpImage $tmpImage
	## Reassign atnimg to the flipped tmpImage 
	atnimg=$tmpImage
fi

## Exports for scatter par file
## Outputs
export total_additive_prefix scatter_prefix
## Input data
export sino_input atnimg NORM acf3d randoms3d scatter_pardir
## Scatter sim arguments
export num_scat_iters scatter_recon_num_subiterations scatter_recon_num_subsets
## masks (debug)
export mask_projdata_filename mask_image


## Computations
# Compute ACF using STIR
echo "Compute attenuation coefficient factors"
calculate_attenuation_coefficients --ACF ${acf3d} ${atnimg} ${sino_input}

# Compute scatter and additive sinogram
echo "Estimate scatter time. This takes time..."
estimate_scatter ${scatter_par}

# Rename total additive sinogram to the OutputAdditiveSinogramFilename
echo "Creating Output: ${OutputAdditiveSinogramFilename}"
stir_math -s ${OutputAdditiveSinogramFilename} "${total_additive_prefix}_${num_scat_iters}.hs"

echo "Creating Multiplicative Factors: ${OutputMultiplicativeFactorsFilename}"
stir_math -s --mult ${OutputMultiplicativeFactorsFilename} ${NORM} ${acf3d}

## Optional cleanup
if [ ${cleanup} == 1 ]; then
	echo "Cleaning up unneeded data!"
	rm -r extras/
	rm ${acf3d%.hs}*
	rm ${mask_image}*
	rm ${scatter_prefix}*
	rm ${mask_projdata_filename}*
	rm ${total_additive_prefix}*
	rm ${randoms3d_prefix}*
else
	echo "Not performing cleanup."
fi

echo "Done with ${0}"
echo "Total additive sinogram has been saved as: ${OutputAdditiveSinogramFilename}"
echo "Multiplicative factors has been saved as: ${OutputMultiplicativeFactorsFilename}"
exit 0
