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

Created:  Mon 11 May 2020

This directory contains some sub macro files used for the GATE simulation.
Note: Any paths to files/directories link are relative to the current working directory.


Files
=======

* AttenuationConv.dat: this file contain the thresholds relative to the input attenuation image for assigning attenuation values to each tissue class
* cuts.mac: sets cut in region for phantom and detector crystal
* GateMaterials.db: contains material used to create the attenuation map
* phantomReg.mac: here the attenuation phantom is defined. This macro creates dmap.hdr and dmap.img, associated to the input image. When running array-jobs this can create conflics between parallel jobs as the files gets over-written. It's recommended to comment out "/gate/VoxPhantom/geometry/buildAndDumpDistanceTransfo dmap.hdr" once it's created. Check that the offset is set correctly. More comments in the macro
* physics.mac: contains the physics list
* source.mac: here the source phantom is defined. Check that the offset is set correctly. More comments in the macro
