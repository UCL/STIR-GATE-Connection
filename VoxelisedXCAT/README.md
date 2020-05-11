# Input

Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
Author: Kris Thielemans<br />
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

Voxel-sizes etc are currently hard-wired. Sorry.


Directories
===========

* images: Contains input and output images.
* GATESubMacros: Contains a collection of GATE macros for simulation.
* root_output: Contains templates for unlisting and is used as the output of the GATE simulation.


Files
=======

* activity.h33: header file for the activity image. Links to images/input/a_act_1.bin
* attenuation.h33: header file for the attenuation image. Links to images/input/a_atn_1_mod.v. This attenuation image needs to be the one converted in "int" (i.e. multiplied by 1000).
* AttenuationConv.dat: this file contain the thresholds relative to the input attenuation image for assigning attenuation values to each tissue class
* CheckGeometry: this script can be used to visualise scanner and activity images from GUI: Gate --qt CheckGeometry.mac
* main_mMR_muMap_job.mac: main macro file.
* phantomReg.mac: here the attenuation phantom is defined. This macro creates dmap.hdr and dmap.img, associated to the input image. When running array-jobs this can create conflics between parallel jobs as the files gets over-written. It's recommended to comment out "/gate/VoxPhantom/geometry/buildAndDumpDistanceTransfo dmap.hdr" once it's created. Check that the offset is set correctly. More comments in the macro
* source.mac: here the source phantom is defined. Check that the offset is set correctly. More comments in the macro
* visualisation.mac: used in CheckGeometry.mac to visualise scanner and phantoms
* physics.mac: contains the physics list
* GateMaterials.db: contains material used to create the attenuation map

Scripts
=======
* prepare_files.sh: shell script that copies scanner files from the specified scanner example directory. This script is required to be run first to copy the correct data into VoxelisedXCAT directory.
* create_root_and_unlist.sh: bash script called from the main. The output root files is removed after the unlisting. comment out that line if you want to keep it.
* job_gate_atten_time.sh: main bash script. Currently the root outputs are stored in the scratch folder. The directory can be changed to any other directory. Provide the absolute path.
* run_gate_single_job.sh: simpler script if you just want to run one job

