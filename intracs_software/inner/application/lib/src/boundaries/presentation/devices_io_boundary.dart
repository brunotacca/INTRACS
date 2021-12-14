import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class DeviceOutputDTO {
  final String deviceName;
  final String deviceUID;
  final bool? availableToConnect;
  final bool? connected;
  DeviceOutputDTO({
    required this.deviceName,
    required this.deviceUID,
    this.availableToConnect,
    this.connected,
  });
}

class DeviceInputDTO {
  final String deviceName;
  final String deviceUID;
  DeviceInputDTO({
    required this.deviceUID,
    required this.deviceName,
  });
}

abstract class GetDevicesAvailable implements InputBoundaryNoParams {}

abstract class GetDevicesAvailableOutput
    implements OutputBoundary<List<DeviceOutputDTO>> {}

abstract class ConnectToDevice implements InputBoundary<DeviceInputDTO> {}

abstract class ConnectToDeviceOutput
    implements OutputBoundary<DeviceOutputDTO> {}

extension DeviceSettingsParsing on Device {
  DeviceOutputDTO parseAsOutputDTO() {
    return DeviceOutputDTO(
      availableToConnect: this.availableToConnect,
      connected: this.connected,
      deviceName: this.deviceName,
      deviceUID: this.deviceUID,
    );
  }
}

extension DeviceInputParsing on DeviceInputDTO {
  Device parseAsDevice() {
    return Device(
      deviceUID: this.deviceUID,
      deviceName: this.deviceName,
    );
  }
}
