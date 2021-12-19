import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';
import 'dart:developer';

class BluetoothDeviceUARTService implements GatheringRawDataSource {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final ReceivedRawDataEventController _receivedRawDataEventController;
  BluetoothDeviceUARTService(this._receivedRawDataEventController);
  bool _started = false;
  BluetoothDevice? connectedDevice;
  BluetoothService? uartService;
  BluetoothCharacteristic? uartTransmitter;
  BluetoothCharacteristic? uartReceiver;
  Stream<List<int>>? uartReceiverValueStream;
  StreamSubscription<dynamic>? uartReceiverValueStreamSubscription;

  static const _UART_SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  static const _UART_TX_CHAR_UUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  static const _UART_RX_CHAR_UUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  bool isEverythingConfigured() =>
      connectedDevice != null &&
      uartTransmitter != null &&
      uartReceiver != null;

  Future _setConnectedSensorDevice() async {
    if (connectedDevice == null) {
      List<BluetoothDevice> devices = await _flutterBlue.connectedDevices;
      for (BluetoothDevice device in devices) {
        if (device.name.contains("Sensor")) {
          connectedDevice = device;
          break;
        }
      }
    }
  }

  Future _lookupForUARTService() async {
    if (connectedDevice == null) return;
    if (connectedDevice != null) {
      // discover the services for the connected device
      await connectedDevice!.discoverServices().then((bluetoothServices) {
        // for each service discovered
        bluetoothServices.forEach((service) {
          // if it's the service UUID I want
          if (service.uuid.toString() == _UART_SERVICE_UUID) {
            uartService = service;
          }
        });
      });

      // if uartService exists
      if (uartService != null) {
        // for each of its characteristic
        uartService!.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == _UART_TX_CHAR_UUID) {
            uartTransmitter = characteristic;
          }
          if (characteristic.uuid.toString() == _UART_RX_CHAR_UUID) {
            uartReceiver = characteristic;
          }
        });
      }
    }
  }

  void _setupStreamAndSubscriptions() {
    if (connectedDevice == null ||
        uartTransmitter == null ||
        uartReceiver == null) return;

    if (uartTransmitter != null && uartReceiver != null) {
      uartReceiver!.setNotifyValue(true);
      uartReceiverValueStream = uartReceiver!.value;
      _cancelSubscription();
      _startSubscriptionAndListen();
    }

    log("TRANSMITTER: " + uartTransmitter.toString());
  }

  final String separator = ";";
  String _receivedRawDataStringParser(List<int> data) {
    // log("DATA: " + data.join(":"));
    String msg = "";
    for (int i = 0; i < data.length; i += 2) {
      if (i == 0) {
        msg += fromByteToChar(data[0]) + fromByteToChar(data[1]) + separator;
      } else {
        msg += fromBytesToInt16(data[i + 1], data[i]).toString();
        if (i < data.length - 2) msg += separator;
      }
    }
    return msg;
  }

  String fromByteToChar(int charByte) {
    List<int> listByte = [charByte];
    var byte = Int8List.fromList(listByte);
    var blob = ByteData.sublistView(byte);
    return String.fromCharCode(blob.getInt8(0));
  }

  int fromBytesToInt16(int lsb, int msb) {
    List<int> listBytes = [lsb, msb];
    var bytes = Int8List.fromList(listBytes);
    var blob = ByteData.sublistView(bytes);
    return blob.getInt16(0);
  }

  void _startSubscriptionAndListen() {
    if (uartReceiverValueStreamSubscription == null) {
      uartReceiverValueStreamSubscription =
          uartReceiverValueStream!.listen((event) {
        String stringData = _receivedRawDataStringParser(event);
        if (_started) {
          String? sensorName;
          int? sensorNumber;
          DateTime now = DateTime.now();
          List<String> listData = stringData.split(separator);
          sensorName = listData[0].substring(0, 1);
          sensorNumber = int.tryParse(listData[0].substring(1)) ?? -1;

          XYZ acc = XYZ(
            x: (int.tryParse(listData[1])! / 100),
            y: (int.tryParse(listData[2])! / 100),
            z: (int.tryParse(listData[3])! / 100),
          );
          XYZ gyr = XYZ(
            x: (int.tryParse(listData[4])! / 100),
            y: (int.tryParse(listData[5])! / 100),
            z: (int.tryParse(listData[6])! / 100),
          );
          XYZ mag = XYZ(
            x: (int.tryParse(listData[7])! / 100),
            y: (int.tryParse(listData[8])! / 100),
            z: (int.tryParse(listData[9])! / 100),
          );

          RawData rawData = RawData(
            count: dataCount,
            timestamp: now,
            sensor: Sensor(
              name: sensorName,
              number: sensorNumber,
            ),
            accelerometer: acc,
            gyroscope: gyr,
            magnetometer: mag,
          );

          if (sensorNumber == 1) dataCount++;
          // log("- RAW DATA: $rawData");
          _receivedRawDataEventController.register(Success(rawData));
        }
      });
    }
  }

  void _cancelSubscription() {
    if (uartReceiverValueStreamSubscription != null) {
      uartReceiverValueStreamSubscription!.cancel();
      uartReceiverValueStreamSubscription = null;
    }
  }

  int dataCount = 0;
  @override
  Future<Result<Exception, bool>> startGatheringRawData() async {
    log("startGatheringRawData()> _started: $_started");
    if (_started) {
      return Success(true);
    } else {
      if (!isEverythingConfigured()) {
        await _setConnectedSensorDevice();
        await _lookupForUARTService();
        _setupStreamAndSubscriptions();
        await Future.delayed(Duration(milliseconds: 200));
      }
      if (isEverythingConfigured()) {
        await _sendUARTMessage("#START");
        _started = true;
        dataCount = 0;
        return Success(true);
      } else {
        _started = false;
        return Failure(Exception("Something is wrong with BLE configuration"));
      }
    }
  }

  @override
  Future<Result<Exception, bool>> stopGatheringRawData() async {
    log("stopGatheringRawData()> _started: $_started");
    if (!_started) {
      return Success(false);
    } else {
      await _sendUARTMessage("#STOP");
      _started = false;
      return Success(false);
    }
  }

  /// Send an UART message to the connected device.
  Future _sendUARTMessage(String msg) async {
    try {
      await uartTransmitter!.write(utf8.encode(msg), withoutResponse: true);
    } catch (e) {
      // try to resend message if exception poped up.
      await Future.delayed(Duration(microseconds: 100));
      await uartTransmitter!.write(utf8.encode(msg), withoutResponse: true);
    }
  }

  @override
  Future<Result<Exception, int>> getAmountRawDataGatheredSinceStart() {
    // TODO: implement getAmountRawDataGatheredSinceStart
    throw UnimplementedError();
  }

  @override
  Future<Result<Exception, int>> getSecondsElapsedSinceStart() {
    // TODO: implement getSecondsElapsedSinceStart
    throw UnimplementedError();
  }

  @override
  Future<Result<Exception, bool>> isGatheringRawData() {
    // TODO: implement isGatheringRawData
    throw UnimplementedError();
  }
}
