<p align="center">
<img src=".imgs_doc/logo-git.png">
</p>

**INTRACS** - **In**ertial **Tra**cker **Com**puting **S**ystem

INTRACS is a software made to ease the process of gathering raw data from inertial sensors wirelessly, and make use of them through a computing method (algorithm - e.g. sensor fusion) in order to output the transformed raw data. It's structured following the guidelides of clean architecture along with some layers and components customizations in order to achieve the range of functionality needed. 

As of now, the provided app is capable of gathering and computing raw data coming via bluetooth from a custom inertial unit made with arduino sam architecture. The inertial device prototype presented is assembled with a custom 3rd party (TinyCircuits) hardware, made with an Atmel SAMD21 32-bit ARM Cortex M0+ processor. It has the potential to support 32 9-Axis IMUs (eigth stacked Wireling Adapters with four 9Axis Wirelings each adapter), sending the data via bluetooth through a simple byte structure. It's also meant to be open-source and low-cost compared to the market alternatives. 

## Documentation

* [Setup and Configuration](GET_STARTED.md)
* [Project Architecture](PROJECT_ARCHITECTURE.md)
* [Contributing to INTRACS](CONTRIBUTING.md)
* [Getting help](SUPPORT.md)
* [Be nice to everyone](CODE_OF_CONDUCT.md)

## The application

<p align="center">
<img src=".imgs_doc/app-datamonitorpage-rawdata-on.jpeg" height="400px"> <img src=".imgs_doc/app-datamonitorpage-computeddata-on.jpeg" height="400px">
</p>

The images above shows the collected raw data from two 9 axis sensors being shown on the screen as long as the computed data, the computing method applied is a sensor fusion called RTQF, a simplified version of Kalman Filter using quaternions, from RTIMU library (richards-tech).

## The inertial device

<p align="center">
<img src=".imgs_doc/intracs-inertial-device.png" height="350px">
</p>

The image above shows the inertial device that was assembled using TinyCircuits boards with the wirelings platform. There are one processor board, one Bluetooth 4.1 board, one wireling adapter board with 4 channels, two wireling 9 axis IMU, cables and a 150mAh battery.