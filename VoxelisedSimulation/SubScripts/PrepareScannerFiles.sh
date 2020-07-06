#! /bin/sh

## AUTHOR: Kris Thielemans 
## AUTHOR: Robert Twyman
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0

# This script will copy the relavant scanner csorter, digitiser, and geometry files 
# into the Voxelised XCAT directory for simulation for a particular scanner.

# The Required Args:
# - $1: Either "D690" or "mMR" must be specified as scanner type as that is all that 
#       is currently supported.

if [ $# -ne 2 ]; then
  echo "Usage:"$0 "ScannerType StoreRootFilesDirectory" 1>&2
  exit 1
fi

ScannerType=$1
StoreRootFilesDirectory=$2

if [ ! -d $StoreRootFilesDirectory ]; then  # Does the output directory exist?
	mkdir -p $StoreRootFilesDirectory
fi

if [ ! -d $StoreRootFilesDirectory/Templates ]; then  # Does the template directory exist?
	mkdir -p $StoreRootFilesDirectory/Templates
fi


if [ $ScannerType = "D690" ]; then
	echo "Preparing D690 scanner files"
	D690_DIR="../ExampleScanners/D690"
	cp -vp $D690_DIR/digitiser_D690.mac GATESubMacros/digitiser.mac
	cp -vp $D690_DIR/geometry_D690.mac GATESubMacros/geometry.mac
	cp -vp $D690_DIR/root_header_template.hroot $StoreRootFilesDirectory/Templates/root_header_template.hroot
	cp -vp $D690_DIR/STIRScanner_D690_full_segment.hs $StoreRootFilesDirectory/Templates/STIR_scanner.hs

elif [ $ScannerType = "mMR" ]; then
	echo "Preparing mMR scanner files"
	mMR_DIR="../ExampleScanners/mMR"
	cp -vp $mMR_DIR/digitiser_mMR.mac GATESubMacros/digitiser.mac
	cp -vp $mMR_DIR/geometry_mMR.mac GATESubMacros/geometry.mac
	cp -vp $mMR_DIR/root_header_template.hroot $StoreRootFilesDirectory/Templates/root_header_template.hroot
	cp -vp $mMR_DIR/STIR_scanner.hs $StoreRootFilesDirectory/Templates/STIR_scanner.hs

else
	echo "Invalid scanner name parsed. Please indicate 'D690' or 'mMR'."
	exit 1
fi

exit 0
