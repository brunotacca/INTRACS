import 'package:intracs_application/application.dart';

class DevicesViewModel {
  final String deviceName;
  final String deviceUID;
  final bool? availableToConnect;
  final bool? connected;
  DevicesViewModel({
    required this.deviceName,
    required this.deviceUID,
    this.availableToConnect,
    this.connected,
  });
}

extension DevicesViewModelParsing on DeviceOutputDTO {
  DevicesViewModel parseAsViewModel() {
    return DevicesViewModel(
      deviceName: this.deviceName,
      deviceUID: this.deviceUID,
      availableToConnect: this.availableToConnect,
      connected: this.connected,
    );
  }
}
