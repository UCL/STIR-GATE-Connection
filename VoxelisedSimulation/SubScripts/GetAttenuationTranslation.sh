#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to automatically gather GATE x,y,z attenuation translation for STIR images.
## Script echo (returns) x y z variables.

ImageFilename=$1

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "ImageFilename" 1>&2
  exit 1
fi

set -e # exit on error
trap "echo ERROR in $0" ERR

## Get first and last edge positions
FirstEdges=`list_image_info $ImageFilename| awk -F: '/Physical coordinate of first edge in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2
LastEdges=`list_image_info $ImageFilename| awk -F: '/Physical coordinate of last edge in mm/ {print $2}'|tr -d '{}'|awk -F, '{print $3, $2, $1}'` 1>&2

## Extract x,y first and last edges
FirstEdgeX=$(echo "$FirstEdges" | awk '{print $1}')
LastEdgeX=$(echo "$LastEdges" | awk '{print $1}')
FirstEdgeY=$(echo "$FirstEdges" | awk '{print $2}')
LastEdgeY=$(echo "$LastEdges" | awk '{print $2}')

## Compute Translation
TranslationX=$(echo "$FirstEdgeX $LastEdgeX" | awk '{print ($1+$2)/2}')
TranslationY=$(echo "$FirstEdgeY $LastEdgeY" | awk '{print ($1+$2)/2}')
TranslationZ=0.  ## Z translation should be zero.

## Used for return.
echo $TranslationX $TranslationY $TranslationZ

exit 0
