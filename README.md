# STIR-GATE-Connection
[![zenodo-badge]][zenodo-link]

Author: Robert Twyman <br />
Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
Author: Francesca Leek<br />
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
- create a GATE compatible voxelised phantom from a STIR parameter files or interfiles using STIR functionality,
- setup and run GATE in cluster array jobs,
- combine and unlist root files into STIR compatible sinograms for reconstruction, and
- compute normalisation factors, scatter correction, and random correction from the measured GATE data using STIR.


See `STIR-GATE-Connection/VoxelisedSimulation/README.md` for a Tutorial.

New to STIR? Checkout the website (http://stir.sourceforge.net/) and github (https://github.com/UCL/STIR).
New to GATE? Checkout their website (http://www.opengatecollaboration.org/) and their incredibly useful UsersGuide (https://opengate.readthedocs.io/en/latest/index.html). 

Requirements
=============

This project is reliant on: ROOT, current STIR `master` branch (https://github.com/UCL/STIR/tree/master) installed with ROOT support, and GATE version 9.0. GATE has dependancy on Geant4 and ROOT. Both STIR install `bin` and GATE `bin` must be in your `PATH`.

STIR-GATE-Connection requires the `SGCPATH` enviromental variable to be set to this primary directory (containing this README file). Many scripts use this variable when executing sub-scripts.

The project is designed to be run on Linux or Unix (MacOS does normally work) using Shell/Bash/Zsh. Furthermore, the project uses programs, such as `sed` and `awk`, for various manipulations. 


Directories
===========

* `ExamplesOfScannersMacros/`: Contains examples of macros for creating a scanner in GATE.
* `ExamplesOfPhantomMacros/`: Contains examples of macros and STIR parameter files for creating/importing source and attenuation phantoms.
* `VoxelisedSimulation/`: Main GATE simulation directory.
* `ExampleReconstruction/`: Contains example scripts for iterative reconstruction using STIR, e.g. OSEM.
* `DataCorrectionsComputation/`: Contains scripts to compute the data corrections for iterative image reconstruction, including: normalisation and attentuation correction coefficients, plus randoms and scattered estimations of the measured data.


Files
=====

* `this_SGC.sh`: This script sets the `SGCPATH` enviromental variable. It also adds `SGCPATH` to PATH. Additional enviromental variables are added for the major project directories. See script for more details.


Acknowledgements
================
Additional help with testing an early stage of the macros:
- Catherine Scott (UCL/UCLH)
- Ana Margarida Motta (Universidade de Lisboa)

[zenodo-badge]: https://zenodo.org/badge/262778436.svg
[zenodo-link]: https://zenodo.org/badge/latestdoi/262778436
