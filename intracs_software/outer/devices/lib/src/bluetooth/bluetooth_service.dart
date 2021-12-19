import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_devices/devices.dart';

class BluetoothService implements TransmissionStateSource, DevicesSource {
  final ChangedTransmissionStateEventController
      _changedTransmissionStateEventController;

  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  Stream<BluetoothState>? _streamBluetoothState;
  Stream<bool>? _streamIsScanning;
  bool _flutterBlueIsScanning = false;
  Stream<List<ScanResult>>? _streamScanResult;
  List<ScanResult> _scanResults = [];
  Map<String, StreamSubscription<BluetoothDeviceState>>
      _mapDeviceStateSubscription = {};
  Map<String, BluetoothDevice> _mapDevices = {};

  BluetoothService(this._changedTransmissionStateEventController) {
    Future.microtask(() async {
      _flutterBlue.isAvailable.then((value) {
        if (value) {
          _streamBluetoothState = _flutterBlue.state;
          _streamBluetoothState!.listen((value) {
            _updateState(value);
          });
          _streamIsScanning = _flutterBlue.isScanning;
          _streamIsScanning!.listen((event) {
            _flutterBlueIsScanning = event;
          });
          _streamScanResult = _flutterBlue.scanResults;
          _streamScanResult!.listen((event) {
            log("Scanned: $event");
            _scanResults = event;
          });
        } else {
          _updateState(BluetoothState.unavailable);
        }
      });
    });
  }

  _updateState(BluetoothState? value) {
    Result<Exception, TransmissionState> r =
        Failure(Exception(BluetoothState.unknown));
    if (value != null) {
      r = Success(TransmissionStateMapper.getTransmissionState(
          BluetoothStateModel(state: value)));
    }
    _changedTransmissionStateEventController.register(r);
  }

  @override
  Future<Result<Exception, TransmissionState>> readTransmissionState() async {
    Result<Exception, TransmissionState> r =
        Failure(Exception("No transmission state values"));
    await _streamBluetoothState?.last.then(
      (value) {
        r = Success(TransmissionStateMapper.getTransmissionState(
            BluetoothStateModel(state: value)));
      },
    ).onError(
      (error, stackTrace) {
        r = Failure(Exception("$error: $stackTrace"));
      },
    );

    return r;
  }

  @override
  Future<Result<Exception, Device>> connectToDevice(Device device) async {
    Result<Exception, Device> r = Failure(Exception("null"));

    List<BluetoothDevice> connectedDevices =
        await _flutterBlue.connectedDevices;
    if (connectedDevices.isNotEmpty) {
      BluetoothDevice? bluetoothDevice = _mapDevices[device.deviceUID];
      if (bluetoothDevice == null) {
        bluetoothDevice = connectedDevices.last;
      }
      return Success(Device(
        deviceName: bluetoothDevice.name,
        deviceUID: bluetoothDevice.id.toString(),
        connected: true,
        availableToConnect: false,
      ));
    }

    await _mapDevices[device.deviceUID.toString()]
        ?.connect(
      autoConnect: true,
      timeout: Duration(seconds: 6),
    )
        .onError(
      (error, stackTrace) {
        r = Failure(Exception(error));
      },
    ).then(
      (value) {
        r = Success(Device(
          deviceName: device.deviceName,
          deviceUID: device.deviceUID,
          connected: true,
          availableToConnect: false,
        ));
      },
    );

    return r;
  }

  List<Device> _flutterBlueScanDevices = [];
  int _scanTimeout = 8;

  @override
  Future<Result<Exception, List<Device>>> readAllDevicesAvailable() async {
    if (!_flutterBlueIsScanning) {
      await _flutterBlue.startScan(timeout: Duration(seconds: _scanTimeout));
      if (_scanResults.isNotEmpty) {
        _flutterBlueScanDevices.clear();
        _mapDevices.clear();
        // Run through the devices and register their state streams if needed
        _scanResults.forEach((element) async {
          if (element.advertisementData.connectable) {
            _mapDevices.addAll({element.device.id.toString(): element.device});
            _mapDeviceStateSubscription
                .putIfAbsent(element.device.id.toString(), () {
              return element.device.state.listen(
                (event) {
                  _mapDevices.addAll({
                    element.device.id.toString(): element.device,
                  });
                },
              )
                ..onError(
                  (err) {
                    _mapDeviceStateSubscription
                        .remove(element.device.id.toString());
                  },
                )
                ..onDone(
                  () {
                    _mapDeviceStateSubscription
                        .remove(element.device.id.toString());
                  },
                );
            });

            _flutterBlueScanDevices.add(Device(
              deviceName: element.device.name,
              deviceUID: element.device.id.toString(),
              availableToConnect: element.advertisementData.connectable,
            ));
            await Future.delayed(Duration(seconds: 2));
          }
        });
      }
      log("LOG DEVICES: " + _flutterBlueScanDevices.toString());
    }
    return Success(_flutterBlueScanDevices);
  }
}
