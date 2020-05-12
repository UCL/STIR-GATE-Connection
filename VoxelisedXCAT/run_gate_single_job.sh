## AUTHOR: Ludovica Brusaferri
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

SGE_TASK_ID=1;
StartTime=$(($(($SGE_TASK_ID-1))))
EndTime=$(($(($SGE_TASK_ID))))


StoreRootFilesDirectory=$PWD

if [ ! -d $StoreRootFilesDirectory ]; then
mkdir -p $StoreRootFilesDirectory

fi

./create_root_and_unlist.sh $SGE_TASK_ID $StartTime $EndTime $StoreRootFilesDirectory
















































