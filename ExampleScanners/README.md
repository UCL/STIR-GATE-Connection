# ExamplesOfScanners

Author: Ludovica Brusaferri<br />
Author: Elise Emond<br />
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

This directory contains examples of implemented scanners. These are GE Discovery 690 (D690) and Seimens mMR (mMR). 

These directories should include the scanner specific `digitiser`, `geometry`, STIR interfile header, and template `hroot` file.

Notes
=======

* The orientation of the ECAT mMR scanner differs to STIR axies orientation: it's shifted of half a block (4 detectors). It needs offset (num of detectors) := -4 in the root header file.

