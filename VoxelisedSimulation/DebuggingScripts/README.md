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

Created:  Mon 22 July 2020

This directory contains a collection of scripts that are useful for debugging. Please note, these may not be maintained and are generally used for development.

Scripts
=======

* `DebugUnlistRoot.sh`: Uses STIR's `exclude [event_type] events :=` keywords to unlist the root file to obtain sinograms with only Trues, Scattered, Randoms and RandomScattered events. This script is useful for debugging the unlisting of root files.
