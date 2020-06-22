#! /bin/sh
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## An example of how to use this STIR-GATE-Connection project.

## This script runs sub_scripts/generate_STIR_GATE_images.sh 
## to generate images from a parameter file using STIR.
## Additional modifications are made to the interfile header 
## for GATE compatibility.


echo "Script initialised:" `date +%d.%m.%y-%H:%M:%S`

##### ==============================================================
## Activity and attenuation files
##### ==============================================================

## Generate example STIR activity and attenuation images and copy to main dir.
ActivityPar=images/input/generate_uniform_cylinder.par
AttenuationPar=images/input/generate_atten_cylinder.par

ActivityFilename="my_uniform_cylinder.h33"
AttenuationFilename="my_atten_image_GATE.h33"

##### ==============================================================
## GATE Arguments and files
##### ==============================================================

## OPTIONAL: Editable fields required by GATE macro scripts
GATEMainMacro="main_muMap_job.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
SGE_TASK_ID=1  ## Job index for parallel GATE simulations
StartTime=1  ## Start time in GATE time
EndTime=1.1  ## End time in GATE time
StoreRootFilesDirectory=root_output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples (eg. D690/mMR).


## Get the scanner files into GATESubMacros directory.
./sub_scripts/prepare_scanner_files.sh $ScannerType $StoreRootFilesDirectory

./SetupSimulation.sh $ScannerType $StoreRootFilesDirectory $ActivityPar $AttenuationPar


##### ==============================================================
## Run GATE
##### ==============================================================

./run_GATE.sh $GATEMainMacro $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $SGE_TASK_ID $StartTime $EndTime


##### ==============================================================
## Unlist GATE data
##### ==============================================================

./sub_scripts/unlist.sh $StoreRootFilesDirectory $SGE_TASK_ID


echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0

