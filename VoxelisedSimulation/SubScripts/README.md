# Input

Author: Robert Twyman<br />
Copyright (C) 2020 University College London<br />
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

Created:  Mon 18 May 2020 16:00 BST

This directory contains a collection of scripts that are key to automatically finding and computing variables for GATE simulations.

Scripts
=======
* `GenerateSTIRGATEImages.sh`: Generates STIR images from parameter files for GATE simulation. The attenuation file voxel values are heavily scaled and should not be used in STIR. Use the original attenuation file.
* `GetAttenuationTranslation.sh`: shell script that reads an image with STIR and returns shifts for the attenuation translation.
* `GetSourcePosition.sh`: shell script that reads an image with STIR and returns the source position offset for GATE
* `PrepareScannerFiles.sh`: shell script that copies scanner files from the specified scanner example directory. This script is required to be run first to copy the correct data into `VoxelisedSimulation/`.
* `STIR2GATE_interfile.sh`: shell script that converts STIR generated interfile headers (.hv) into GATE compatible headers (.h33) files and adds the parameters "!number of slices" and "slice thickness (pixels)".
*WARNING* the `get_*.sh` scripts put the centre of the STIR image at the GATE 0,0,0.  
Therefore they assume that the GATE scanner is defined as in `ExamplesOfScanners`. Shifting the centre of the GATE scanner is currently going to break things.
* `SumData.sh`: A script that sums a number of image/sinogram data into a common file.
* `UnlistRoot.sh`: script used to unlist a `*.root` file. Creates a `*.hroot` with the correct filename and energy information and paramerter file for STIR's `lm_to_projdata` functionality. 

Comments
=======
* Concatenating root files: Use the ROOT provided tool `hadd` (`hadd --help` for more information).
* Combining interfile sinograms: Use `stir_math`.
