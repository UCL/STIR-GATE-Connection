# !/bin/bash

## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## Voxelised attenuation images are required to be of type int (for segmentation). 
## This script takes an interfile image as input and multiplied all values for GATE. 

export input=$1
export output=$2

if [ $# -ne 2 ]; then
  echo "Error in $0 with number of arguments"
  echo "Usage: $0 input_attenuation_filename output_attenuation_filename" 1>&2
  exit 1
fi

# Multiply by 10000
stir_math --including-first --times-scalar 10000 $output $input
# example
#stir_math --including-first --times-scalar 10000 input_image_atn_1_mod input_image_atn_1.hv

# Change to int32
#stir_math --accumulate $output template_int32.hv 
