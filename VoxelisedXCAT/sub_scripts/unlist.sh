

StoreRootFilesDirectory=$1
RootFilename=$2
SGE_TASK_ID=$3
# ScannerType="mMR"

if [ $# -ne 3 ]; then
  echo "Usage:"$0 "StoreRootFilesDirectory RootFilename SGE_TASK_ID" 1>&2
  exit 1
fi

# sh sub_scripts/prepare_scanner_files.sh $ScannerType $StoreRootFilesDirectory

cd $StoreRootFilesDirectory

#============= create parameter file from template =============
cp  Templates/lm_to_projdata_template.par lm_to_projdata_${SGE_TASK_ID}.par
sed -i "" "s/SGE_TASK_ID/$SGE_TASK_ID/g" lm_to_projdata_$SGE_TASK_ID.par
sed -i "" "s/UNLISTINGDIRECTORY/UnlistedSinograms/g" lm_to_projdata_${SGE_TASK_ID}.par


cp  Templates/root_header_template.hroot  root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/SGE_TASK_ID/${SGE_TASK_ID}/g" root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/LOWTHRES/0/g" root_header_${SGE_TASK_ID}.hroot
sed -i "" "s/UPTHRES/1000/g" root_header_${SGE_TASK_ID}.hroot

lm_to_projdata lm_to_projdata_${SGE_TASK_ID}.par




