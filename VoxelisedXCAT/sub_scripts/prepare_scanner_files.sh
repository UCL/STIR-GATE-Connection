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

if [ $# -ne 1 ]; then
  echo "Usage:"$0 "ScannerType" 1>&2
  exit 1
fi

ScannerType=$1

if [ $ScannerType = "D690" ]; then
	echo "Preparing D690 scanner files"
	D690_DIR="../ExamplesOfScannersMacros/D690"
	cp -vp $D690_DIR/csorter_D690.mac GATESubMacros/csorter.mac
	cp -vp $D690_DIR/digitiser_D690.mac GATESubMacros/digitiser.mac
	cp -vp $D690_DIR/geometry_D690.mac GATESubMacros/geometry.mac

elif [ $ScannerType = "mMR" ]; then
	echo "Preparing mMR scanner files"
	mMR_DIR="../ExamplesOfScannersMacros/mMR"
	cp -vp $mMR_DIR/csorter_mMR.mac GATESubMacros/csorter.mac
	cp -vp $mMR_DIR/digitiser_mMR.mac GATESubMacros/digitiser.mac
	cp -vp $mMR_DIR/geometry_mMR.mac GATESubMacros/geometry.mac

else
	echo "Invalid scanner name parsed. Please indicate 'D690' or 'mMR'."
fi

exit 0
