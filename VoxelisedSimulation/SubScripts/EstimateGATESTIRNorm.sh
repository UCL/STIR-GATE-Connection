## #! /bin/sh

## AUTHOR: Robert Twyman
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0

## Script is used to compute the normalisation factors for GATE data reconstruction.
## The current standard to do this is to forward project, in STIR and GATE (run simulations), a cylindrical activity, the size of the scanner FOV, without attenuation.
## The measured_data (sinogram) is obtained by unlisting the GATE output with the exclusion of randoms and scatter.

## This script forward projects the same activity cylinder in SITR to obtain model_data. 
## The script will estimate the norm factors (norm_sino.hs) using STIR functionality. 
## See find_ML_normfactors3D and apply_normfactors3D for more information

## PARAMETERS

## Model Data Setup
FOVCylindricalActivityFilename="activity.hv"
STIR_Scanner_template=main_GATE_sim_dir/Output/Templates/STIR_scanner.hs

## Measured Data
measured_data=GATE_sino_DIR/GATE_sino.hs

## ML Normfactors loop numbers
outer_iters=5
eff_iters=6

## The filename of the data forward projected using STIR (Hardcoded)
model_data=STIR_forward.hs
OutputFilename=norm_sino.hs

## Forward project using SITR to get model data
forward_project STIR_forward $FOVCylindricalActivityFilename $STIR_Scanner_template


## find ML normfactors
echo "find_ML_normfactors3D"
find_ML_normfactors3D norm_factors $measured_data $model_data $outer_iters $eff_iters


## create ones sino
echo "stir_math"
stir_math -s --including-first --times-scalar 0 --add-scalar 1 ones.hs $model_data


## mutiply ones with the norm factors to get a sino
echo "apply_normfactors3D"
apply_normfactors3D ${OutputFilename} norm_factors $model_data 1 $outer_iters $eff_iters

