Author: Robert Twyman<br />
Author: Kris Thielemans<br />
Author: Francesca Leek<br />
Copyright (C) 2021 University College London<br />
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

Created:  Mon 28 Apr 2021

This directory contains scripts that can be used to compute the data corrections for iterative image reconstuction. 

Scripts
=======
* `EstimateGATESTIRNorm.sh`: Creates normalisation correction sinogram from GATE measured data and STIR model data.<br />
   *Warning:* You will need to make sure that the projector that you use during reconstruction matches the one used for the estimation of the norm factors. See `forward_projector_proj_matrix_ray_tracing.par`.
* `ComputePoissonDataCorrection.sh`: Computes the data correction terms for PET reconstruction from the data measured output by GATE simulations. This script estimates the contribution due to randoms and scatter in the measured data and computes the multiplicative factors for STIR image reconstruction.
* `EstimateRandomsFromDelays.sh`: Creates a sinogram of the randoms estimation from Delayed coincidence data.

Files
=======
* `forward_projector_proj_matrix_ray_tracing.par`: Forward projector parameters for normalisation computation. See `EstimateGATESTIRNorm.sh`
