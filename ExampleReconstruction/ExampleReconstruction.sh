#! /bin/sh
## AUTHOR: ROBERT TWYMAN
## Copyright (C) 2021 University College London
## Licensed under the Apache License, Version 2.0


# ExampleReconstruction.sh script perform OSEM as an example reconstruction for GATE data.
#  The required inputs are as follow:
#		Coincidence Data Filename
#		Additive Sinogram Filename
#		Multiplicative Factors Filename
# Optional inputs are:
# 		The number of subsets
# 		The number of subiterations


Prompts=$1 # This should be the unlisted output of the GATE simulations
AdditiveSinogram=$2 # The estimated contributions due to random and scattered events
MultFactors=$3 # The geometric, physical, and attuation factors of the simulation.
# Note, the AdditiveSinogram and MultFactors can be computed using 
# the `ComputePoissonDataCorrections.sh` script.

# Default for optional variables for the reconstruction
NumSubsets=8
NumSubiterations=40

echo " "
echo "Running ExampleReconstruction.sh"
echo " "


## Usage message
if [ $# -lt 3 ]; then 
	echo "USAGE: $0 CoincidenceData AdditiveSinogram MultiplicativeFactors [NumSubsets NumSubiterations]"
	echo "  Where NumSubsets and NumSubiterations are optional."
fi

# Handle optional arguemnts
if [ $# -ge 5 ]; then
	NumSubsets=$4
	NumSubiterations=$5
fi

# Print configuration to terminal
echo "The reconstruction files provided are as follow:"
echo "  Coincidence Data[Prompts] = ${Prompts}"
echo "  Additive Sinogram[AdditiveSinogram] = ${AdditiveSinogram}"
echo "  Multiplicative Factors [MultFactors] = ${MultFactors}"
echo "  Number of Subsets [NumSubsets] = ${NumSubsets}"
echo "  Number of Subiterations [NumSubiterations] = ${NumSubiterations}"

# Export variables for the parameter files
export Prompts AdditiveSinogram MultFactors NumSubsets NumSubiterations

echo "Performing image reconstruction!"
OSMAPOSL ${SGCPATH}/ExampleReconstruction/OSEM.par
echo "Image reconstruction complete!"
