import 'package:hive/hive.dart';
import 'package:intracs_entities/entities.dart';

import 'device_model.dart';

part 'user_settings_model.g.dart';

@HiveType(typeId: 1)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  DeviceModel? connectedDevice;
  @HiveField(1)
  bool? listeningTransmissionChanges;
  UserSettingsModel({
    this.connectedDevice,
    this.listeningTransmissionChanges,
  });

  UserSettings asEntity() => UserSettings(
        connectedDevice: this.connectedDevice?.asEntity() ?? null,
        listeningTransmissionChanges: this.listeningTransmissionChanges,
      );

  @override
  String toString() =>
      'BookModel(device: $connectedDevice, listeningTransmissionChanges: $listeningTransmissionChanges)';

  UserSettingsModel copyWith({
    DeviceModel? connectedDevice,
    bool? listeningTransmissionChanges,
  }) {
    return UserSettingsModel(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      listeningTransmissionChanges:
          listeningTransmissionChanges ?? this.listeningTransmissionChanges,
    );
  }
}
