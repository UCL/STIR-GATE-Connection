#$ -S /bin/bash

## AUTHOR: Robert Twyman
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

## Shell script to run CheckGeometry.mac - visualising the scanner. Handles some of the positional and translational
## arguments in SubMacros files.

ActivityFilename=$1
AttenuationFilename=$2

echo "Script initialised:" $(date +%d.%m.%y-%H:%M:%S)

## Get the scanner files into main directory.
sh sub_scripts/prepare_scanner_files.sh D690

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


## Run Gate with --qt for visualise
Gate --qt CheckGeometry.mac -a \
[ActivityFilename,$ActivityFilename][AttenuationFilename,$AttenuationFilename]\
[SourcePositionX,$SourcePositionX][SourcePositionY,$SourcePositionY][SourcePositionZ,$SourcePositionZ]\
[AttenuationTranslationX,$AttenuationTranslationX][AttenuationTranslationY,$AttenuationTranslationY][AttenuationTranslationZ,$AttenuationTranslationZ]


echo "Script finishied: " $(date +%d.%m.%y-%H:%M:%S)
