# This script should be run before any reconstruction.

# This script will:
#	- Copy files from correct scanner geometry (runs sub_scripts/prepare_scanner.sh)
#	- OPTIONAL: Creates voxelised phantom from parameter files
#	- Opens Gate and creates DMAP for phantom (this should only be run once per phantom.)



# {add parameter checks}
if [ $# != 4 ]
then
	echo "SetupSimulation: Setup scanner, voxelised phantom files and dmap"
	echo "Usage: ScannerType StoreRootFilesDirectory ActivityPar AttenuationPar"
	exit 1
fi

# Parameters
ScannerType
StoreRootFilesDirectory

ActivityPar
AttenuationPar


## Get the scanner files into GATESubMacros directory.
./sub_scripts/prepare_scanner_files.sh $ScannerType $StoreRootFilesDirectory




## Generate example STIR activity and attenuation images and copy to main dir.
ActivityPar=images/input/generate_uniform_cylinder.par
AttenuationPar=images/input/generate_atten_cylinder.par

SourceFilenames=`sub_scripts/generate_STIR_GATE_images.sh $ActivityPar $AttenuationPar 2>/dev/null`
## Get activity and attenuation filenames from $SourceFilenames
ActivityFilename=`echo ${SourceFilenames} |awk '{print $1}'`
AttenuationFilename=`echo ${SourceFilenames} |awk '{print $2}'`


# Run Gate DMAP setup
Gate SetupDmap.mac
