# INTRACS
**In**ertial **Tra**cker **Com**puting **S**ystem

INTRACS is a software made to ease the process of gathering raw data from inertial sensors wirelessly, and make use of then through a computing process (e.g. sensor fursion) in order to output the transformed raw data.

It's structured following the guidelides of clean architecture along with some layers and components customizations in order to achieve the range of functionality needed. 

The first prototype provided is a mobile app gathering and computing raw data coming via bluetooth from a custom inertial unit made with arduino sam architecture. The inertial unit presented here is assembled with a custom 3rd party (TinyCircuits) hardware, made with an Atmel SAMD21 32-bit ARM Cortex M0+ processor, same one used in the Arduino Zero. 

The inertial unit has the potential to support 32 9-Axis IMUs (eigth stacked Wireling Adapters with four 9Axis Wirelings each adapter), sending all data via bluetooth through a simple byte structure. It's also meant to be open-source and low-cost compared to the market alternatives. 

The example shows its usage with two 9Axis sensors and a sensor fusion called RTQF, a simplified version of Kalman Filter using quaternions, from RTIMU library (richards-tech).

## A
## B
## C
## D
## E
## F
## G
## H