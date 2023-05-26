# Power Apps Mixed Reality - Take Measurements Demo

## Overview
This is a simple canvas app to demonstrate the Mixed Reality Measurements control available in Power Apps today.  The control allows the user to measure width, height and depth of objects in their space.  For more on the control see: https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/mixed-reality-component-measure-distance

## Solution Details
The solution includes the following:
- Measurement Tool: a canvas App w/ Mixed Reality Measurement control
- MR Demo - Save Measurements: A flow that saves the data from the measurement control to Dataverse
- MR Demo Measurement: a Dataverse table to store the measurements taken
- MR Demo Photo: a Dataverse table to store photos taken related to each measurement
- MR Demo Segment: a Dataverse table to store each segment of a measurement (e.g. height, width and depth of an object)

Sample solution file can be downloaded here,

[Mixed Reality Proof of Concept Solution File](files/MixedRealityPOC_1_0_0_4.zip)

## Requirements
This solution requires a premium license (Power Apps Per User or Per App).  It has been successfully tested in GCC


