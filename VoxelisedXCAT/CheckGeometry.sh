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
QT=1  # Tell run_GATE.sh to use QT visualisation


## For "CheckGeometry.mac" these arguments have no effect, used to satisfy "run_GATE.sh" arguments
StoreRootFilesDirectory=root_output  # There is no file output from GATE
SGE_TASK_ID=1  # No parallel processing required as no output
StartTime=0  # Hardcoded in "CheckGeometry.mac"
EndTime=1  # Hardcoded in "CheckGeometry.mac"

echo "Script initialised:" $(date +%d.%m.%y-%H:%M:%S)

## Get the scanner files into main directory.
sub_scripts/prepare_scanner_files.sh $ScannerType $StoreRootFilesDirectory

./run_GATE.sh $GATEMainMacro $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $SGE_TASK_ID $StartTime $EndTime $QT

echo "Script finished: " $(date +%d.%m.%y-%H:%M:%S)
exit 0
