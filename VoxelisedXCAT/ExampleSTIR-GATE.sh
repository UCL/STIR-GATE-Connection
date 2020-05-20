## AUTHOR: ROBERT TWYMAN
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## An example of how to use this STIR-GATE-Connection project.

## Before running please setup activitiy and attenuation files. 
## In the VoxelisedXCAT directory activitiy.h33 and attenuation.h33 
## exists, which by default link to: 'images/input/a_act_1.bin' and 
## 'images/input/a_att_1.bin'. 

## This script runs images/input/generate_STIR_images/generate_STIR_images.sh 
## to generate images using STIR before GATE simulation performed. The script 
## computes SourcePosition and AttenuationTranslation from the images using 
## sub_scripts/get_source_position.sh and sub_scripts/get_attenuation_translation.sh.

echo "Script initialised:" $(date +%d.%m.%y-%H:%M:%S)

##### ==============================================================
## Activity and attenuation files
##### ==============================================================

## Generate example STIR activity and attenuation images and copy to main dir.
ActivityPar=generate_uniform_cylinder.par
AttenuationPar=generate_atten_cylinder.par

SourceFilenames=$( sub_scripts/generate_STIR_GATE_images.sh $ActivityPar $AttenuationPar 2>/dev/null ) 
ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`

## Activity and Attenuation header filenames (Optional: Use your own files)
# ActivityFilename="activity.h33"
# AttenuationFilename="attenuation.h33"

##### ==============================================================
## GATE Arguments and files
##### ==============================================================

## Optional editable fields required by GATE macro scripts
SGE_TASK_ID=1
StartTime=1
EndTime=1.1
StoreRootFilesDirectory=root_output
ScannerType="D690"

## Get the scanner files into main directory.
sh sub_scripts/prepare_scanner_files.sh $ScannerType

## Get the activity source position in x,y,z
SourcePositions=$( sub_scripts/get_source_position.sh $ActivityFilename 2>/dev/null ) 
SourcePositionX=`echo ${SourcePositions} |awk '{print $1}'`
SourcePositionY=`echo ${SourcePositions} |awk '{print $2}'`
SourcePositionZ=`echo ${SourcePositions} |awk '{print $3}'`

## Get the attenuation map translation in x,y,z
AttenuationTranslations=$( sub_scripts/get_attenuation_translation.sh $AttenuationFilename 2>/dev/null ) 
AttenuationTranslationX=`echo ${AttenuationTranslations} |awk '{print $1}'`
AttenuationTranslationY=`echo ${AttenuationTranslations} |awk '{print $2}'`
AttenuationTranslationZ=`echo ${AttenuationTranslations} |awk '{print $3}'`

##### ==============================================================
## Run GATE
##### ==============================================================

Gate main_muMap_job.mac -a \
[SimuId,$SGE_TASK_ID]\
[StartTime,$StartTime][EndTime,$EndTime]\
[StoreRootFilesDirectory,$StoreRootFilesDirectory]\
[ActivityFilename,$ActivityFilename][AttenuationFilename,$AttenuationFilename]\
[SourcePositionX,$SourcePositionX][SourcePositionY,$SourcePositionY][SourcePositionZ,$SourcePositionZ]\
[AttenuationTranslationX,$AttenuationTranslationX][AttenuationTranslationY,$AttenuationTranslationY][AttenuationTranslationZ,$AttenuationTranslationZ]


##### ==============================================================
## Unlist GATE data
##### ==============================================================
## ... todo.

echo "Script finished: " $(date +%d.%m.%y-%H:%M:%S)

exit 0

