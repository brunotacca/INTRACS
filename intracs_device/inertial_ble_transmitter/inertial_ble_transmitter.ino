//-------------------------------------------------------------------------------
//  INTRACS Inertial BLE UART Transmistter
//
//  This code was adapted from the example sketch provided by TinyCircuits
//  to set up the BlueNRG-MS chipset of the ST BLE module for compatiblity
//  with Nordic's virtual UART connection, and can pass data between the Arduino
//  serial monitor and Nordic nRF UART V2.0 app or another compatible BLE
//  terminal.
//  TinyCircuits example written by Ben Rose, TinyCircuits http://tinycircuits.com 
//  (2 March 2016)
//
//  Written by Bruno Tacca.
//  Last Updated Aug 28, 2021
//-------------------------------------------------------------------------------

#include <SPI.h>
#include <STBLE.h>
#include <Wire.h>
#include <Wireling.h>

// For the communication with the LSM9DS1
#include "RTIMUSettings.h"    
#include "RTIMU.h"
// #include "RTFusionRTQF.h"

//Debug output adds extra flash and memory requirements!
#ifndef BLE_DEBUG
#define BLE_DEBUG true
#endif

#ifndef ARDUINO_ARCH_SAMD
#include "EEPROM.h"
#endif

/*#if defined (ARDUINO_ARCH_AVR)
#define SerialMonitorInterface Serial
#el*/
#if defined(ARDUINO_ARCH_SAMD)
#define SerialMonitorInterface SerialUSB
#endif

#include <stdio.h>
char sprintbuffer[100];
#define SPRINTF(...) {sprintf(sprintbuffer,__VA_ARGS__);if(SerialMonitorInterface)SerialMonitorInterface.print(sprintbuffer);}
#define NL() {SPRINTF("\n");}

// #include "MySerialPrintLibrary.h"
// MySerialPrintLibrary mySerialPrintLibrary;

// BlueNRG-MS payload max len
const uint8_t ble_txrx_buffer_max_len = 21;
const uint8_t ble_tx_max_msg_len = 20;

// UART Receiver
uint8_t ble_rx_buffer[ble_txrx_buffer_max_len];
uint8_t ble_rx_buffer_len = 0;

// UART Transmitter
uint8_t ble_tx_buffer[ble_txrx_buffer_max_len];
uint8_t ble_tx_buffer_len = 0;

uint8_t ble_connection_state = false;
#define PIPE_UART_OVER_BTLE_UART_TX_TX 0

RTIMU *imu;                         // the IMU object being read
// RTFusionRTQF fusion0;                // the fusion object
// RTFusionRTQF fusion1;                // the fusion object
RTIMUSettings settings;             // the settings object
int BLE_MSG_INTERVAL = 12;
const int SENSORS_AMOUNT = 2;
const int DISPLAY_INTERVAL = SENSORS_AMOUNT*BLE_MSG_INTERVAL;         // interval between displays

const double ERRORS_PER_THOUSAND_ALLOWED = 1.0;
const int MAX_BLE_MSG_INTERVAL = 25;
const int MIN_BLE_MSG_INTERVAL = 5;
double ERRORS_PER_THOUSAND = ERRORS_PER_THOUSAND_ALLOWED;
double ERROR_COUNTER = 0;
int LAST_SAMPLECOUNT_BLEINTERVAL_UPDATE = 0;
const int CHECK_UPDATE_INTERVAL_AFTER_AT_LEAST = 500;

// Global variables to retrieve, store, and schedule readings from the sensor
unsigned long lastDisplay;
unsigned long lastRate;
int sampleCount;
int errorSyncSampleCount;
RTVector3 accelData;
RTVector3 gyroData;
RTVector3 compassData;
// RTVector3 fusionData0; 
// RTVector3 fusionData1; 

int wirelingSelectedPort = 0; // Wireling actual selected port
int wirelingSelectedSensorNumber = 0; // Representativa number for the selected sensor

bool allSensorsReady = false;

bool sensor0Created = false;
bool sensor0Calibrated = false;
int sensor0port = 0;

bool sensor1Created = false;
bool sensor1Calibrated = false;
int sensor1port = 3;

// Struct for optimal 9DOF sensor data
typedef struct {
  int16_t ax; int16_t ay; int16_t az; // Accelerometer  x y z; double values * 100
  int16_t gx; int16_t gy; int16_t gz; // Gyroscope      x y z; double values * 100
  int16_t mx; int16_t my; int16_t mz; // Magnetometer   x y z; double values * 100
} SensorData;

SensorData sensor0data, sensor1data;
const char sensor0id[2] = {'S','0'};
const char sensor1id[2] = {'S','1'};

String commandToStartSending = "#START";
String commandToStopSending = "#STOP";
bool collectAndSendData = false;

void setup() {  
  SerialMonitorInterface.begin(115200);
  // while (!SerialMonitorInterface); //This line will block until a serial monitor is opened with TinyScreen+!

  // Serial_* serialPrint;
  // serialPrint = &SerialMonitorInterface;  
  // mySerialPrintLibrary.begin(serialPrint);

  BLEsetup();
  delay(100);

  // Initialize Wireling
  Wireling.begin();
  delay(100);

  allSensorsReady = false;
  ble_connection_state = false;
  collectAndSendData = false;

  lastDisplay = lastRate = millis();
  sampleCount = 0;

  // fusion0.setSlerpPower(0.02);
  // fusion0.setGyroEnable(true);
  // fusion0.setAccelEnable(true);
  // fusion0.setCompassEnable(true);

  // fusion1.setSlerpPower(0.02);
  // fusion1.setGyroEnable(true);
  // fusion1.setAccelEnable(true);
  // fusion1.setCompassEnable(true);
}

void loop() {
  BLELoop();
  if(allSensorsReady && ble_connection_state && collectAndSendData) {
    WirelingLoop();
  } else {
    InitializeAndCalibrateSensors();
  }
}

void selelectWirelingPort(int port) {
    wirelingSelectedPort = port;
    Wireling.selectPort(wirelingSelectedPort); // Select 9-Axis Sensor at Port
    if(wirelingSelectedPort == sensor0port) wirelingSelectedSensorNumber = 0;
    else if(wirelingSelectedPort == sensor1port) wirelingSelectedSensorNumber = 1;
}

void InitializeAndCalibrateSensors() {
    selelectWirelingPort(sensor0port);
    if(!sensor0Created) {
      sensor0Calibrated = false;
      CreateAndStartCalibrationIMUObject();
      delay(100);
      sensor0Created = true;
    } else if(!sensor0Calibrated) {
      sensor0Calibrated = CalibrateIMU();
    }

    if(sensor0Created && sensor0Calibrated) {
      selelectWirelingPort(sensor1port);
      if(!sensor1Created) {
        sensor1Calibrated = false;
        CreateAndStartCalibrationIMUObject();
        delay(100);
        sensor1Created = true;
      } else if(!sensor1Calibrated) {
        sensor1Calibrated = CalibrateIMU();
      }
    }

    if(sensor0Created && sensor0Calibrated && sensor1Created && sensor1Calibrated)
      allSensorsReady = true;
}

void CreateAndStartCalibrationIMUObject() {
  int errcode;
  imu = RTIMU::createIMU(&settings);        // create the imu object

  // SPRINTF("ArduinoIMU begin using device %s  at Port: %d\n",imu->IMUName(),wirelingSelectedPort);
  if ((errcode = imu->IMUInit()) < 0) {
    // SPRINTF("Failed to init IMU: %d",errcode);
  }

  // See line 69 of RTIMU.h for more info on compass calibaration 
  if (imu->getCalibrationValid()) {
    // SPRINTF("Using compass calibration"); NL();
  } else {
    // SPRINTF("No valid compass calibration data");  NL();
  }
}


void BLELoop() {
  aci_loop(); //Process any ACI commands or events from the NRF8001- main BLE handler, must run often. Keep main loop short.

  // Check if data is available at RX (Receiver)
  if (ble_connection_state && ble_rx_buffer_len) { 
    // SPRINTF("RX[%d]: %s",ble_rx_buffer_len,(char*)ble_rx_buffer);
    // NL();
    ble_rx_buffer_len = 0; //clear afer reading

    // if connected, wait for the sync char at rx buffer to start sending the singals.
    String received = (char*)ble_rx_buffer;
    if(commandToStartSending==received) {
      collectAndSendData = true;
    }
    if(commandToStopSending==received) {
      collectAndSendData = false;
    }
  }


  // if (SerialMonitorInterface.available()) {//Check if serial input is available to send
  //   delay(10);//should catch input
  //   uint8_t sendBuffer[21];
  //   uint8_t sendLength = 0;
  //   while (SerialMonitorInterface.available() && sendLength < 20) {
  //     sendBuffer[sendLength] = SerialMonitorInterface.read();
  //     sendLength++;
  //   }
  //   SerialMonitorInterface.print("sendLength: "); SerialMonitorInterface.println(sendLength);
  //   SerialMonitorInterface.print("SerialMonitorInterface.available(): "); SerialMonitorInterface.println(SerialMonitorInterface.available());
    
  //   if (SerialMonitorInterface.available()) {
  //     SerialMonitorInterface.print(F("Input truncated, dropped: "));
  //     if (SerialMonitorInterface.available()) {
  //       SerialMonitorInterface.write(SerialMonitorInterface.read());
  //     }
  //   }
  //   // sendBuffer[sendLength] = '\0'; //Terminate string
  //   // sendLength++;
  //   if (uint8_t err = !lib_aci_send_data(PIPE_UART_OVER_BTLE_UART_TX_TX, (uint8_t*)sendBuffer, sendLength))
  //   {
  //     SerialMonitorInterface.print(F("TX dropped! err:")); SerialMonitorInterface.println(err);
  //   }
  // }  
}

int8_t getMsb(int16_t u16) {
  return u16;
}
int8_t getLsb(int16_t u16) {
  return u16 >> 8;
}

int16_t joinInt8(uint8_t lsb, uint8_t msb) {
  return (int16_t) (lsb << 8) | (msb);
}

void composeAndSendSensorsData() {
  // SerialMonitorInterface.println(" ---------------- Compose and Send data");
  // SerialMonitorInterface.print("- S0 "); printIMUStruct(sensor0data);
  // SerialMonitorInterface.print("- S1 "); printIMUStruct(sensor1data);
  // SerialMonitorInterface.println("----------------");

  ble_tx_buffer_len=0;
  ble_tx_buffer[ble_tx_buffer_len++] = sensor0id[0];
  ble_tx_buffer[ble_tx_buffer_len++] = sensor0id[1];
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.ax); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.ax);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.ay); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.ay);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.az); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.az);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.gx); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.gx);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.gy); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.gy);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.gz); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.gz);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.mx); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.mx);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.my); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.my);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor0data.mz); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor0data.mz);
  sendBuffer();

  ble_tx_buffer_len=0;
  ble_tx_buffer[ble_tx_buffer_len++] = sensor1id[0];
  ble_tx_buffer[ble_tx_buffer_len++] = sensor1id[1];
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.ax); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.ax);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.ay); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.ay);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.az); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.az);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.gx); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.gx);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.gy); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.gy);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.gz); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.gz);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.mx); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.mx);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.my); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.my);
  ble_tx_buffer[ble_tx_buffer_len++] = getMsb(sensor1data.mz); ble_tx_buffer[ble_tx_buffer_len++] = getLsb(sensor1data.mz);
  sendBuffer();

  checkErrorAndUpdateBleIntervalIfNeeded();

}

void sendBuffer() {
  uint8_t err = !lib_aci_send_data(PIPE_UART_OVER_BTLE_UART_TX_TX, (uint8_t*)ble_tx_buffer, ble_tx_buffer_len);
  if (err>0) {
    // SerialMonitorInterface.print(F("TX dropped! err:")); SerialMonitorInterface.println(err);
    ERROR_COUNTER++;
  }
 
  delay(BLE_MSG_INTERVAL);
}

void checkErrorAndUpdateBleIntervalIfNeeded() {
  // Is it time to update?
  if(errorSyncSampleCount>CHECK_UPDATE_INTERVAL_AFTER_AT_LEAST && (errorSyncSampleCount-LAST_SAMPLECOUNT_BLEINTERVAL_UPDATE)>CHECK_UPDATE_INTERVAL_AFTER_AT_LEAST) {
    ERRORS_PER_THOUSAND = double(ERROR_COUNTER / double(errorSyncSampleCount/1000.0));
    LAST_SAMPLECOUNT_BLEINTERVAL_UPDATE = errorSyncSampleCount;
    if(BLE_MSG_INTERVAL<=MAX_BLE_MSG_INTERVAL || BLE_MSG_INTERVAL>=MIN_BLE_MSG_INTERVAL) {
      // if too much errors
      if(ERRORS_PER_THOUSAND > ERRORS_PER_THOUSAND_ALLOWED) {
        if(BLE_MSG_INTERVAL<MAX_BLE_MSG_INTERVAL) BLE_MSG_INTERVAL++;
        if(BLE_MSG_INTERVAL<=MAX_BLE_MSG_INTERVAL) resetAndSyncErrorsIfTooHighOrLow();
      } 
      // if too few errors
      else if(ERRORS_PER_THOUSAND < ERRORS_PER_THOUSAND_ALLOWED) {
        if(BLE_MSG_INTERVAL>MIN_BLE_MSG_INTERVAL) BLE_MSG_INTERVAL--;
        if(BLE_MSG_INTERVAL>=MIN_BLE_MSG_INTERVAL) resetAndSyncErrorsIfTooHighOrLow();
      }
    }
    // SPRINTF("----------------\n");
    // SPRINTF("sampleCount: %d\n",sampleCount);
    // SPRINTF("rate: %d\n",BLE_MSG_INTERVAL);
  }
}

void resetAndSyncErrorsIfTooHighOrLow() {
  if(ERRORS_PER_THOUSAND<0.5 || ERRORS_PER_THOUSAND>2.0) {
    if(ERRORS_PER_THOUSAND>2.5) errorSyncSampleCount = 1.0;
    if(ERRORS_PER_THOUSAND<0.5) errorSyncSampleCount = 2000.0;
    ERROR_COUNTER = ERRORS_PER_THOUSAND_ALLOWED;
    ERRORS_PER_THOUSAND = ERRORS_PER_THOUSAND_ALLOWED;
    LAST_SAMPLECOUNT_BLEINTERVAL_UPDATE = errorSyncSampleCount;
  }
}

void printBufferTranslated() {
  SPRINTF("BUFFER[%d] TRANSLATED> ",ble_tx_buffer_len);
  SPRINTF("%c%c", ble_tx_buffer[0],ble_tx_buffer[1]);
  for (int i = 2; i < ble_tx_buffer_len; i+=2) {
    SPRINTF(",");
    SPRINTF("%d", joinInt8(ble_tx_buffer[i+1],ble_tx_buffer[i]));
  }
  SPRINTF("\n");
}

bool CalibrateIMU() {
  unsigned long now = millis();
  unsigned long delta;
  bool calibrated = false;
  if (imu->IMURead()) {     // get the latest data if ready 
    // fusion.newIMUData(imu->getGyro(), imu->getAccel(), imu->getCompass(), imu->getTimestamp());
    sampleCount++;
    if ((delta = now - lastRate) >= 1000) {
      // SerialMonitorInterface.print("IMU: "); SerialMonitorInterface.print(imu->IMUName());
      // SerialMonitorInterface.print(" at Port: "); SerialMonitorInterface.print(wirelingSelectedPort);
      // SerialMonitorInterface.print(" | Sample rate: "); SerialMonitorInterface.print(sampleCount);
      if (imu->IMUGyroBiasValid()) {
        // SerialMonitorInterface.println(", gyro bias valid");
        calibrated = true;
      } else {
        // SerialMonitorInterface.println(", calculating gyro bias - don't move IMU!!");
        calibrated = false;
      }

      sampleCount = 0;
      lastRate = now;
    }
  }
  return calibrated;
}

void WirelingLoop() {
  unsigned long now = millis();
  if ((now - lastDisplay) >= DISPLAY_INTERVAL) {
    // SPRINTF("%d,",sampleCount); 
    // if(sampleCount%50==0) SPRINTF("\n");
    sampleCount++; errorSyncSampleCount++;

    // SPRINTF("----------------------------------------------- %d,",sampleCount); NL();
    // Sensor 0
    selelectWirelingPort(sensor0port);
    readIMUData();
    sensor0data = getIMUSensorDataAsStruct();
    // fusion0.newIMUData(imu->getGyro(), imu->getAccel(), imu->getCompass(), imu->getTimestamp(), mySerialPrintLibrary);
    // fusionData0 = fusion0.getFusionPose();
    //displayAxis("0 Pose:", fusionData0.x(), fusionData0.y(), fusionData0.z());      
    //displayDegrees("0 Pose:", fusionData0.x(), fusionData0.y(), fusionData0.z());      

    // SPRINTF("----------------------------------------------- %d,",sampleCount); NL();
    // Sensor 1
    selelectWirelingPort(sensor1port);
    readIMUData();
    sensor1data = getIMUSensorDataAsStruct();
    // fusion1.newIMUData(imu->getGyro(), imu->getAccel(), imu->getCompass(), imu->getTimestamp(), mySerialPrintLibrary);
    // fusionData1 = fusion1.getFusionPose();
    //displayAxis("1 Pose:", fusionData1.x(), fusionData1.y(), fusionData1.z());      
    // displayDegrees("1 Pose:", fusionData1.x(), fusionData1.y(), fusionData1.z());      
    // SPRINTF("-----------------------------------------------"); NL();
    // SPRINTF("-----------------------------------------------"); NL();

    // Compose and Send data through BLE
    composeAndSendSensorsData();
  }
}

// Prints out pieces of different radian axis data to Serial Monitor
void displayAxis(const char *label, float x, float y, float z) {
  SerialMonitorInterface.print(label);
  SerialMonitorInterface.print(" x:"); SerialMonitorInterface.print(x);
  SerialMonitorInterface.print(" y:"); SerialMonitorInterface.print(y);
  SerialMonitorInterface.print(" z:"); SerialMonitorInterface.print(z);
  SerialMonitorInterface.println();   
}

// Converts axis data from radians to degrees and prints values to Serial Monitor
void displayDegrees(const char *label, float x, float y, float z) {
  SerialMonitorInterface.print(label);
  SerialMonitorInterface.print(" x:"); SerialMonitorInterface.print(x * RTMATH_RAD_TO_DEGREE);
  SerialMonitorInterface.print(" y:"); SerialMonitorInterface.print(y * RTMATH_RAD_TO_DEGREE);
  SerialMonitorInterface.print(" z:"); SerialMonitorInterface.print(z * RTMATH_RAD_TO_DEGREE);
  SerialMonitorInterface.println();   
}

void readIMUData() {
  unsigned long now = millis();
  if (imu->IMURead()) { // get the latest data if ready 
    lastDisplay = now;
  }
}

SensorData getIMUSensorDataAsStruct() {
  SensorData data;
  if(imu) {
    // Get updated readings from sensor and update those values in the respective RTVector3 object
    accelData = imu->getAccel();
    gyroData = imu->getGyro();
    compassData = imu->getCompass();

    data.ax = (int16_t) round(accelData.x() * 100.00);
    data.ay = (int16_t) round(accelData.y() * 100);
    data.az = (int16_t) round(accelData.z() * 100);
    data.gx = (int16_t) round(gyroData.x() * 100.00);
    data.gy = (int16_t) round(gyroData.y() * 100.00);
    data.gz = (int16_t) round(gyroData.z() * 100.00);
    data.mx = (int16_t) round(compassData.x() * 100.00);
    data.my = (int16_t) round(compassData.y() * 100.00);
    data.mz = (int16_t) round(compassData.z() * 100.00);
  }
  return data;  
}

void printIMUStruct(SensorData imuStruct) {
  SerialMonitorInterface.print("> ");
  SerialMonitorInterface.print(imuStruct.ax); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.ay); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.az); SerialMonitorInterface.print("; ");
  SerialMonitorInterface.print(imuStruct.gx); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.gy); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.gz); SerialMonitorInterface.print("; ");
  SerialMonitorInterface.print(imuStruct.mx); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.my); SerialMonitorInterface.print(",");
  SerialMonitorInterface.print(imuStruct.mz); SerialMonitorInterface.print(";");
  SerialMonitorInterface.print(" sizeof: ");
  SerialMonitorInterface.println(sizeof(imuStruct));
}