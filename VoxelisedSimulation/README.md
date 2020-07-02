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

* `images/`: contains input and output images.
* `GATESubMacros/`: contains a collection of GATE macros for simulation.
* `root_output/`: contains templates for unlisting and is used as the output of the GATE simulation.
* `SubScripts/`: contains a collection of scripts that are key to automatically finding and computing variables for GATE similations.


Files
=======

* `CheckGeometry.mac`: this script can be used to visualise scanner and activity images from GUI: `Gate --qt CheckGeometry.mac` (requires geant4 OpenGL {and maybe QT?}). Note, additional parameters may be required. Refer to `CheckGeometry.sh`. 
* `main_muMap_job.mac`: main macro file for GATE simulation. Utilises macro files within `GATESubMacros/`.


Scripts
=======
* `CheckGeometry.sh`: shell script to run `CheckGeometry.mac` - visualising the scanner. Handles some of the positional and translational arguments in SubMacros files.
* `ExampleSTIR-GATE.sh`: example script to demonstrate how to use this STIR-GATE-Connection project. Generates data using STIR, converts it into a GATE compatible format, before running the GATE simulation.
* `job_CS_example.sh` and `job_Myriad_example.sh.sh`: example UCL CS/Myriad cluster job script to run two parallel GATE simulations in an array job and unlist each root file into seperate sinograms. These two platforms differ in job submission flag keys.
* `run_Gate.sh`: This script take and processes many inputs (see file for more detail) to setup the Gate simulations with the correct macro arguments.
* `SetupSimulation.sh`: Copies all relevent scanner files, if two `*.par` files are given, will atempt to `generate_STIR_GATE_images.sh`, and finally runs a GATE simulation to `SetupDmap.mac`.
