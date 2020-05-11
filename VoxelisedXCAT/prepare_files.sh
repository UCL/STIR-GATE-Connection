#! /bin/sh

## AUTHOR: Kris Thielemans & Robert Twyman
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0

# This script will copy the relavant scanner csorter, digitiser, and geometry files 
# into the Voxelised XCAT directory for simulation for a particular scanner.

# The Required Args:
# - $1: Either "D690" or "mMR" must be specified as scanner type as that is all that 
#       is currently supported.

SCANNERTYPE=$1

if [ $SCANNERTYPE = "D690" ]; then
	echo "Preparing D690 scanner files"
	D690_DIR="../ExamplesOfScannersMacros/D690"
	cp -v $D690_DIR/csorter_D690.mac GateSubMacros/csorter.mac
	cp -v $D690_DIR/digitiser_D690.mac GateSubMacros/digitiser.mac
	cp -v $D690_DIR/geometry_D690.mac GateSubMacros/geometry.mac

elif [ $SCANNERTYPE = "mMR" ]; then
	echo "Preparing mMR scanner files"
	mMR_DIR="../ExamplesOfScannersMacros/mMR"
	cp -v $mMR_DIR/csorter_mMR.mac GateSubMacros/csorter.mac
	cp -v $mMR_DIR/digitiser_mMR.mac GateSubMacros/digitiser.mac
	cp -v $mMR_DIR/geometry_mMR.mac GateSubMacros/geometry.mac

else
	echo "Invalid scanner name parsed. Please indicate 'D690' or 'mMR'."
fi

exit 1
