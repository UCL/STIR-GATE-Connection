#$ -S /bin/bash

## AUTHOR: Robert Twyman
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0

## Shell script to run CheckGeometry.mac - visualising the scanner. Handles some of the positional and translational
## arguments in SubMacros files.

if [ $# -ne 2 ]; then
  echo "Error in $0 with number of arguments"
  echo "Usage: $0 ActivityFilename AttenuationFilename" 1>&2
  echo "This script is used to visualise the scanner geometry in GATE."
  exit 1
fi

GATEMainMacro="CheckGeometry.mac"
ActivityFilename=$1
AttenuationFilename=$2
ScannerType="D690"
QT=1  # Tell RunGATE.sh to use QT visualisation


## For "CheckGeometry.mac" these arguments have no effect, used to satisfy "RunGATE.sh" arguments
StoreRootFilesDirectory=Output  # There is no file output from GATE
TASK_ID=1  # No parallel processing required as no output
StartTime=0  # Hardcoded in "CheckGeometry.mac"
EndTime=0.00000001  # Hardcoded in "CheckGeometry.mac"

echo "Script initialised:" $(date +%d.%m.%y-%H:%M:%S)

## Copy the relevent the scanner files from ExampleScanners into position for simulation.
./SubScripts/PrepareScannerFiles.sh $ScannerType $StoreRootFilesDirectory

## The root_filename is not a variable here but a dummy given to RunGATE
./RunGATE.sh $GATEMainMacro root_filename $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $TASK_ID $StartTime $EndTime $QT

echo "Script finished: " $(date +%d.%m.%y-%H:%M:%S)

exit 0
