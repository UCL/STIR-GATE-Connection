# Input

Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
Author: Kris Thielemans<br />
Author: Robert Twyman<br />
Copyright (C) 2018-2020 University College London<br />
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
<br />
http://www.apache.org/licenses/LICENSE-2.0.txt
<br />
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Created:  Mon 30 Sep 2019 14:07:08 BST

This directory contains the main macro files used for the GATE simulations and example scripts.
Note: Any paths to files/directories link are relative to the current working directory.


Directories
===========

* `DebuggingScripts/`: contains scripts useful for debugging.
* `images/`: contains input and output images.
* `GATESubMacros/`: contains a collection of GATE macros for simulation.
* `Output/`: contains templates for unlisting and is used as the output of the GATE simulation and sinograms of the unlisted data.
* `SubScripts/`: contains a collection of scripts that are key to automatically finding and computing variables for GATE similations.


Files
=======

* `CheckGeometry.mac`: this script can be used to visualise scanner and activity images from GUI: `Gate --qt CheckGeometry.mac` (requires geant4 OpenGL {and maybe QT?}). Note, additional parameters may be required. Refer to `CheckGeometry.sh`. 
* `MainGATE.mac`: main macro file for GATE simulation. Utilises macro files within `GATESubMacros/`.


Scripts
=======
* `CheckGeometry.sh`: shell script to run `CheckGeometry.mac` - visualising the scanner. Handles some of the positional and translational arguments in SubMacros files.
* `ExampleSTIR-GATE.sh`: example script to demonstrate how to use this STIR-GATE-Connection project. Generates data using STIR, converts it into a GATE compatible format, before running the GATE simulation.
* `JobGATESimulationCS.sh` and `JobGATESimulationMyriad.sh`: example UCL CS/Myriad cluster job script to run parallel GATE simulations in an array job. These two platforms differ in job submission flag keys.
* `RunGate.sh`: This script take and processes many inputs (see file for more detail) to setup the Gate simulations with the correct macro arguments.
* `SetupSimulation.sh`: This script should be run before any GATE simulatiuon takes place. The script copies all relevent scanner files to the working directories. If two `*.par` files are given to this script, `GenerateSTIRGATEImages.sh` will use STIR's functionality `generate_image` to create voxelised phantoms. If the script is given STIR readable volumes, it will convert them into a GATE readable form. Please note, this will multiply the attenuation values by `10,000` for GATE simulation setup. Finally, the script initialises a GATE simulation setup (`SetupDmap.mac`). See file for more details.
