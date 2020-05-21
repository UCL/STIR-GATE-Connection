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

SourceFilenames=`sub_scripts/generate_STIR_GATE_images.sh $ActivityPar $AttenuationPar 2>/dev/null`
## Get activity and attenuation filenames
ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`

## OPTIONAL: Insert Activity and Attenuation header filenames HERE
# ActivityFilename="activity.h33"
# AttenuationFilename="attenuation.h33"

##### ==============================================================
## GATE Arguments and files
##### ==============================================================

## OPTIONAL: Editable fields required by GATE macro scripts
GATEMainMacro="main_muMap_job.mac" ## Main macro script for GATE - links to many GATESubMacro/ files 
SGE_TASK_ID=1  ## Job index for parallel GATE simulations
StartTime=1  ## Start time in GATE time
EndTime=1.1  ## End time in GATE time
StoreRootFilesDirectory=root_output  ## Save location of root data
ScannerType="D690"  # Scanner type from Examples.


## Get the scanner files into GATESubMacros directory.
sh sub_scripts/prepare_scanner_files.sh $ScannerType

##### ==============================================================
## Run GATE
##### ==============================================================

sh run_GATE.sh $GATEMainMacro $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $SGE_TASK_ID $StartTime $EndTime


##### ==============================================================
## Unlist GATE data
##### ==============================================================
## ... todo.

echo "Script finished: " `date +%d.%m.%y-%H:%M:%S`

exit 0

