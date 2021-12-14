import 'package:intracs_entities/entities.dart';

/// This might be good in the future to save some state and
/// having decisions made from this
class UserSettings {
  final Device? connectedDevice;
  final bool? listeningTransmissionChanges;

  UserSettings({
    this.connectedDevice,
    this.listeningTransmissionChanges,
  });

  UserSettings copyWith({
    Device? connectedDevice,
    bool? listeningTransmissionChanges,
  }) {
    return UserSettings(
      connectedDevice: connectedDevice ?? this.connectedDevice,
      listeningTransmissionChanges:
          listeningTransmissionChanges ?? this.listeningTransmissionChanges,
    );
  }
}
