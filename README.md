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


About
===========
The purpose of this project is to provide a simple method to: 
- create a GATE compatible voxelised phantom from a parameter file or interfile using STIR functionality
- setup and run GATE in cluster array jobs 
- combine and unlist root files for reconstruction using STIR

See `STIR-GATE-Connection/VoxelisedSimulation/README.md` for a Tutorial.

New to STIR? Checkout the website (http://stir.sourceforge.net/) and github (https://github.com/UCL/STIR).
New to GATE? Checkout their website (http://www.opengatecollaboration.org/) and their incredibly useful UsersGuide (https://opengate.readthedocs.io/en/latest/index.html) for all things GATE. 

Requirements
=============

This project is reliant on: ROOT, a minumum of STIR `release_4` branch (https://github.com/UCL/STIR/tree/release_4) installed with ROOT support or equivilant master, and GATE version 8.2. GATE has dependancy on Geant4 and ROOT. Both STIR install `bin` and GATE `bin` must be in your PATH.


Directories
===========

* `ExamplesOfScannersMacros/`: Contains examples of macros for creating a scanner in GATE.
* `ExamplesOfPhantomMacros/`: Contains examples of macros and STIR parameter files for creating/importing source and attenuation phantoms.
* `VoxelisedSimulation/`: Main GATE simulation directory.


Acknowledgements
================
Additional help with testing an early stage of the macros:
- Catherine Scott (UCL/UCLH)
- Ana Margarida Motta (Universidade de Lisboa)
