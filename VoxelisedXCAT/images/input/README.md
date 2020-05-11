# Input

Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
Copyright (C) 2018-2019 University College London<br />
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

This directory is used to create the input files for the GATE simulation.


Files
=======

* create_XCAT.par: parameter files to generate XCAT images
* CreateXCATImage.sh: creates (i) input_image_atn_1.bin and (ii) input_image_act_1.bin. licence is needed
* input_image_atn_1.hv: Header file for input_image_atn_1.bin. User needs to check that image size and voxel size match with the one of "create_XCAT.par".
* modifyAttenuationImageForGate.sh: the attenuation image needs to be converted from float to int  so that GATE can use its thresholding method to define tissue classes: (we multiplied it by 10000)
