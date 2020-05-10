
## AUTHOR: Ludovica Brusaferri
## Copyright (C) 2018-2019 University College London
## Licensed under the Apache License, Version 2.0

Files=""
Files2=""

for i in {1..100}

do
startFile=$(($((${i}-1))*200 +1))
stopFile=$((${i}*200))
MergeNb=$i
stir_math source_temp${MergeNb}.hv source_merge_${startFile}_${stopFile}.hv




done
stir_math source_total.hv source_temp{1..100}.hv
rm source_temp{1..100}.ahv
rm source_temp{1..100}.hv
rm source_temp{1..100}.v

