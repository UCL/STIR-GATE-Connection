#! /bin/sh
## AUTHOR: ROBERT TWYMAN
## Copyright (C) 2021 University College London
## Licensed under the Apache License, Version 2.0


# ExampleReconstruction.sh script perform OSEM as an example reconstruction for GATE data.
#  The required inputs are as follow:
#		Coincidence Data 
#		Additive Sinogram 
#		Multiplicative Factors"

if [ $# != 3 ]; then 
	echo "USAGE: $0 CoincidenceData[Prompts] AdditiveSinogram MultiplicativeFactors[MultFactors]"
fi

Prompts=$1
AdditiveSinogram=$2
MultFactors=$3

echo "The reconstruction files provided are as follow"
echo "    Coincidence Data[Prompts] = ${Prompts}"
echo "    Additive Sinogram[AdditiveSinogram] = ${AdditiveSinogram}"
echo "    Multiplicative Factors [MultFactors] = ${MultFactors}"

export Prompts AdditiveSinogram MultFactors SGCPATH

echo "Performing image reconstruction!"
OSMAPOSL ${SGCPATH}/ExampleReconstruction/OSEM.par
echo "Image reconstruction complete!"