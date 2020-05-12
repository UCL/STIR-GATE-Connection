#$ -S /bin/bash

## AUTHOR: Ludovica Brusaferri
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

SGE_TASK_ID=$1
StartTime=$2
EndTime=$3
StoreRootFilesDirectory=$4

Gate main_muMap_job.mac -a [SimuId,$SGE_TASK_ID][StartTime,$StartTime][EndTime,$EndTime][StoreRootFilesDirectory,$StoreRootFilesDirectory]

cd root_output

#============= create parameter file from template =============

cp  Templates/lm_to_projdata_template.par lm_to_projdata_${SGE_TASK_ID}.par
sed -i "s/TIMEPLACEHOLDER/${SGE_TASK_ID}/g" lm_to_projdata_${SGE_TASK_ID}.par
sed -i "s/UNLISTINGDIRECTORY/UnlistedSinograms/g" lm_to_projdata_${SGE_TASK_ID}.par
cp  Templates/root_header_template.hroot  root_header_${SGE_TASK_ID}.hroot
sed -i "s/TIMEPLACEHOLDER/${SGE_TASK_ID}/g" root_header_${SGE_TASK_ID}.hroot
sed -i 's|_STORE_|'$StoreRootFilesDirectory'|g' root_header_${SGE_TASK_ID}.hroot
sed -i "s/LOWTHRES/0/g" root_header_${SGE_TASK_ID}.hroot
sed -i "s/UPTHRES/1000/g" root_header_${SGE_TASK_ID}.hroot

#=================== now do the unlisting ================

lm_to_projdata lm_to_projdata_${SGE_TASK_ID}.par


rm ${StoreRootFilesDirectory}/ROOT_OUTPUT_${SGE_TASK_ID}.root
rm lm_to_projdata_${SGE_TASK_ID}.par
rm root_header_${SGE_TASK_ID}.hroot
