# STIR-GATE-Connection

Author: Robert Twyman <br />
Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
Author: Vesna Cuplov <br />
Author: Kris Thielemans <br />
Copyright (C) 2014-2020 University College London<br />
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


Directories
===========

* `ExamplesOfScannersMacros/`: Contains examples of macros for creating a scanner in GATE.
* `ExamplesOfPhantomMacros/`: Contains examples of macros and STIR parameter files for creating/importing source and attenuation phantoms.
* `VoxelisedSimulation/`: Main GATE simulation directory.


Things to do
=============
* change the mMR template to the "real" one (8x8 crystals, not 8x9) (needs STIR mods)
* find XCAT dimensions from the XCAT file as opposed to hard-wiring
* find GATE image specifications from Interfile headers
* find GATE sinogram specifications from STIR Interfile header or vice versa
* can even find durations and energy windows from Interfile headers

Acknowledgements
================
Additional help with testing an early stage of the macros:
- Catherine Scott (UCL/UCLH)
- Ana Margarida Motta (Universidade de Lisboa)