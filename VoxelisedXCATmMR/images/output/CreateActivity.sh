#$ -S /bin/bash
#$ -l h_vmem=1G
#$ -l tmem=1G
#$ -l h_rt=10:00:00

#$ -t 1-100:1
# -tc 20
#$ -cwd
#$ -j y
#$ -N MergeImages

## AUTHOR: Ludovica Brusaferri
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

startFile=$(($((${SGE_TASK_ID}-1))*200 +1))
stopFile=$((${SGE_TASK_ID}*200))

Files=""
Files2=""
Files3=""
Files4=""
for i in $(seq ${startFile} ${stopFile})
do
Files+="Phantom${i}-SourceMap.hdr "
Files2+="Phantom${i}-SourceMap.img "
Files3+="Phantom${i}-MuMap.hdr "
Files4+="Phantom${i}-MuMap.img "
done


stir_math source_merge_${startFile}_${stopFile}.hv ${Files}

if [ -f source_merge_${startFile}_${stopFile}.hv ]; then

rm ${Files}
rm ${Files2} 
rm ${Files3}
rm ${Files4} 


fi

