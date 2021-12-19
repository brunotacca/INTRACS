import 'package:flutter_blue/flutter_blue.dart';
import 'package:intracs_entities/entities.dart';
import 'package:intracs_devices/devices.dart';

class TransmissionStateMapper {
  static TransmissionState getTransmissionState(
      BluetoothStateModel bluetoothStateModel) {
    return TransmissionState(
        _bluetoothStateEnumMapper(bluetoothStateModel.state));
  }

  static TransmissionStateEnum _bluetoothStateEnumMapper(BluetoothState state) {
    switch (state) {
      case BluetoothState.unavailable:
        return TransmissionStateEnum.unavailable;

      case BluetoothState.unauthorized:
        return TransmissionStateEnum.unauthorized;

      case BluetoothState.on:
        return TransmissionStateEnum.turnedOn;

      case BluetoothState.off:
        return TransmissionStateEnum.turnedOff;

      default:
        return TransmissionStateEnum.unknown;
    }
  }

  // connected,
  // transmitting,

}
