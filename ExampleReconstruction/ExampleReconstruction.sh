
# ExampleReconstruction.sh script perform OSEM as an example reconstruction for GATE data.
#  The required inputs are as follow:


Prompts=$1
AdditiveSinogram=$2
MultFactors=$3

echo "The reconstruction files are as follow"
echo "    Coincidence Data[Prompts] = ${Prompts}"
echo "    Additive Sinogram[AdditiveSinogram] = ${AdditiveSinogram}"
echo "    Multiplicative Factors [MultFactors] = ${MultFactors}"

if [ $# != 3 ]; then 
	echo "USAGE: $0 Coincidence Data[Prompts] AdditiveSinogram MultiplicativeFactors[MultFactors]"
fi

export Prompts AdditiveSinogram MultFactors SGCPATH
OSMAPOSL ${SGCPATH}/ExampleReconstruction/OSEM.par