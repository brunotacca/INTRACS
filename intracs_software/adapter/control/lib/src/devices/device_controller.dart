import 'package:intracs_application/application.dart';

class DeviceSender {
  final GetDevicesAvailable _getDevicesAvailable;
  final ConnectToDevice _connectToDevice;
  DeviceSender(this._getDevicesAvailable, this._connectToDevice);

  Future<bool> getDevicesAvailable() async {
    return await _getDevicesAvailable.call();
  }

  Future<bool> connecToDevice(String deviceUID, String deviceName) async {
    DeviceInputDTO device = DeviceInputDTO(
      deviceUID: deviceUID,
      deviceName: deviceName,
    );
    return await _connectToDevice.call(device);
  }
}
