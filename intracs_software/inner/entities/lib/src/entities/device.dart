/// A device is an external hardware accountable for:
/// - Connecting with this software somehow
/// - Having IMU sensors attached to it
/// - Sending raw data from sensors to this software
class Device {
  final int? sampleRate; // samples per seconds
  final String deviceName;
  final String deviceUID;
  final bool? availableToConnect;
  final bool? connected;

  Device({
    this.sampleRate,
    required this.deviceName,
    required this.deviceUID,
    this.availableToConnect,
    this.connected,
  });
}
