#! /bin/sh

## AUTHOR: Kris Thielemans
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0


SCANNERTYPE=$1

if [[ $SCANNERTYPE == "GE" ]]; then
	echo "Preparing D690 scanner files"
	D690_DIR="../ExamplesOfScannersMacros/D690"
	cp $D690_DIR/csorter_D690.mac csorter.mac
	cp $D690_DIR/digitiser_D690.mac digitiser.mac
	cp $D690_DIR/geometry_D690.mac geometry.mac

elif [[ $SCANNERTYPE == "mMR" ]]; then
	echo "Preparing mMR scanner files"
	mMR_DIR="../ExamplesOfScannersMacros/mMR"
	cp $mMR_DIR/csorter_mMR.mac csorter.mac
	cp $mMR_DIR/digitiser_mMR.mac digitiser.mac
	cp $mMR_DIR/geometry_mMR.mac geometry.mac

else
	echo "Invalid script parse. Please indicate 'GE' or 'mMR'."
fi
