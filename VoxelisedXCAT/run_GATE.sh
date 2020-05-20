#! /bin/sh

## AUTHOR: ROBERT TWYMAN
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## Script to run GATE a similation given various arguments. 
## The script computes SourcePosition and AttenuationTranslation 
## from the images using sub_scripts/get_source_position.sh
## and sub_scripts/get_attenuation_translation.sh.


if [ $# -ne 7 ]; then
  echo "Error in $0 with number of arguments"
  echo "Usage: $0 GATEMainMacro ActivityFilename AttenuationFilename SimuId StartTime EndTime" 1>&2
  exit 1
fi

GATEMainMacro=$1
ActivityFilename=$2
AttenuationFilename=$3
StoreRootFilesDirectory=$4
SimuId=$5
StartTime=$6
EndTime=$7


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

Gate $GATEMainMacro -a \
[SimuId,$SimuId]\
[StartTime,$StartTime][EndTime,$EndTime]\
[StoreRootFilesDirectory,$StoreRootFilesDirectory]\
[ActivityFilename,$ActivityFilename][AttenuationFilename,$AttenuationFilename]\
[SourcePositionX,$SourcePositionX][SourcePositionY,$SourcePositionY][SourcePositionZ,$SourcePositionZ]\
[AttenuationTranslationX,$AttenuationTranslationX][AttenuationTranslationY,$AttenuationTranslationY][AttenuationTranslationZ,$AttenuationTranslationZ]
