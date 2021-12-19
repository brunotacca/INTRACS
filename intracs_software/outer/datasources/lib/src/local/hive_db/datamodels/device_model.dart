import 'package:hive/hive.dart';
import 'package:intracs_entities/entities.dart';

part 'device_model.g.dart';

@HiveType(typeId: 2)
class DeviceModel extends HiveObject {
  @HiveField(0)
  String deviceUID;
  @HiveField(1)
  String deviceName;
  DeviceModel({
    required this.deviceUID,
    required this.deviceName,
  });

  @override
  String toString() =>
      'DeviceModel(deviceUID: $deviceUID, deviceName: $deviceName)';

  Device asEntity() => Device(
        deviceName: deviceName,
        deviceUID: deviceUID,
      );
}
