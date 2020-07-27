## AUTHOR: Ludovica Brusaferri
## AUTHOR: Robert Twyman
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

startFile=$(($((${TASK_ID}-1))*200 +1))
stopFile=$((${TASK_ID}*200))

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

if [ -f source_merge_${startFile}_${stopFile}.hv ]
then
	rm ${Files}
	rm ${Files2} 
	rm ${Files3}
	rm ${Files4} 
fi

