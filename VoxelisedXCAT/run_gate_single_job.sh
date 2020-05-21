## AUTHOR: Ludovica Brusaferri
## AUTHOR: Robert TWyman
## Copyright (C) 2018-2020 University College London
## Licensed under the Apache License, Version 2.0

SGE_TASK_ID=1;
StartTime=$(($(($SGE_TASK_ID-1))))
EndTime=$(($(($SGE_TASK_ID))))
ActivityFilename="activity.h33"
AttenuationFilename="attenuation.h33"
StoreRootFilesDirectory=$PWD
GATEMainMacro="main_muMap_job.mac"



if [ ! -d $StoreRootFilesDirectory ]; then
	mkdir -p $StoreRootFilesDirectory
fi

./create_root_and_unlist.sh $GATEMainMacro $ActivityFilename $AttenuationFilename\
			$StoreRootFilesDirectory $SGE_TASK_ID $StartTime $EndTime
