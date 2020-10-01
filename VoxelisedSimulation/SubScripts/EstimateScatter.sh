
## This is my development script for estiamting scatter


## main function estimate_scatter
# USAGE: /Users/roberttwyman/bin/STIR//master/install/bin/estimate_scatter.sh \
#    atten_image emission_proj_data_file template_scatter_proj_data [ ACFfile [NormalisationSinogramsino ]] 
# If the ACFfile parameter is not given, I will use attenuation_coefficients.hs as filename.
# If the ACFfile doesn't exist, I will compute it.
# emission, ACF and NormalisationSinogram all have to have the same sizes.
# template_scatter_proj_data specifies down-sampled sizes for the scatter calculation.
# By default, this script expects scatter.par in 



if [[ $# != 6 ]]; then
	echo "Usage: sh ${0} scatter_estimation.par MeasuredData NormSino RandomsEst AttenuationImage AttenIsGATE"
	echo "The final option (AttenIsGATE) is required because GATE images are inverted in z axis (no idea why...)"
	exit 1
fi

set -e # exit on error
trap "echo ERROR in $0" ERR

echo "====="
echo "Begining Scatter Estimation Script"

scatter_par=$1
MeasuredData=$2
NormalisationSinogram=$3
RandomsEstimate=$4
### inputs
tmpImage=$5
AttenIsGATE=$6

## SETUP: No need to change stuff here, setup for exports

acf3d=attenuation_coefficients.hs

scatter_pardir=$PWD
scatter_prefix=my_scatter
total_additive_prefix=my_total_additive
mask_image=my_mask
mask_projdata_filename=my_sino_mask


num_scat_iters=5
scatter_recon_num_subiterations=18
scatter_recon_num_subsets=18

### Manipulate the attenuation map from GATE
## GATE outputs with an offset and inverted z axis, these methods correct for this


if [ $AttenIsGATE == 1 ]; then
		## Create zeros with 0 origin
	stir_math --times-scalar 0.0 --including-first zeros.hv ../attenuation_corrected_GATE.h33
	stir_math --add $tmpImage zeros.hv $AttenuationImage
	## invert the z axis of $tmpImage if it is a GATE output
	invert_axis "z" $tmpImage $tmpImage
fi

AttenuationImage=$tmpImage

export MeasuredData AttenuationImage NormalisationSinogram acf3d RandomsEstimate scatter_pardir num_scat_iters scatter_prefix total_additive_prefix scatter_recon_num_subiterations scatter_recon_num_subsets
export mask_projdata_filename mask_image


if [ ! -f $acf3d ]; then
	echo "Compute attenuation coefficient factors"
	calculate_attenuation_coefficients --PMRT --ACF $acf3d $AttenuationImage $MeasuredData
fi


echo "Estimate scatter time. This takes time."
## Estimate the scatter
# estimate_scatter ${scatter_par} > /dev/null
estimate_scatter ${scatter_par}


## Check if the total additive = acf * NormalisationSinogram * (scatter est. + randoms est.)
echo "creating multifactors"
stir_math -s --mult my_mutifactors.hs $NormalisationSinogram $acf3d
