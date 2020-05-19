#! /bin/sh
## AUTHOR: Robert Twyman
## Script used to generate activity and attenuation images in STIR. 
## The script copies the .hv files as .h33 (for GATE) and populates 
## NumberOfSlices and SliceThickness in the file.


cd images/input/generate_STIR_images

## Generate source and attenuation images
echo Generating Activity and Attenuation
generate_image generate_uniform_cylinder.par
generate_image generate_atten_cylinder.par
sh ../modifyAttenuationImageForGate.sh my_atten_image.hv my_atten_image_GATE

## Copy my_uniform_cylinder.hv to my_uniform_cylinder.h33 for GATE

## 
for Filename in my_uniform_cylinder my_atten_image_GATE; do
  Filenameh33=$Filename".h33"
  cp $Filename".hv" $Filenameh33
  echo "Adding Number of Slices and Slice Thickness to: $Filenameh33"

  ## Get the number of slices = Number of voxels in z
  NumberOfSlices=`list_image_info $Filenameh33 | awk -F: '/Number of voxels / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
  ## Get slice thickness in z
  SliceThickness=`list_image_info $Filenameh33 | awk -F: '/Voxel-size in mm / {print $2}'|tr -d '{}'|awk -F, '{print $1}'` 1>&2
  ## Get the line number to insert the text into
  LineNum=$( grep -n "first pixel offset (mm) \\[[1]]*]" $Filenameh33 | cut -d : -f 1 )

  # Add $NumberOfSlices and $SliceThickness at $LineNum
  sed -i '' $LineNum'i\
  !number of slices := '$NumberOfSlices'\
  slice thickness (pixels) := '$SliceThickness'
  ' $Filenameh33

  ## Copy the files to the main directory.
  cp $Filenameh33 ../../../
  cp $Filename".v" ../../../

done


