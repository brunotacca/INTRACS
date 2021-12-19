import 'package:intracs_entities/entities.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_datasources/datasources.dart';

class UserSettingsDataSource implements UserSettingsSource {
  final HiveBoxes _hiveBoxes;
  UserSettingsDataSource(this._hiveBoxes);

  DeviceModel? deviceModelFromEntity(Device? device) {
    if (device != null) {
      DeviceModel? model;
      if (device.deviceUID.isNotEmpty) {
        model = _hiveBoxes.boxDevices?.values
            .singleWhere((element) => element.deviceUID == device.deviceUID);
      }
      model
        ?..deviceName = device.deviceName
        ..deviceUID = device.deviceUID;
      return model;
    }
    return null;
  }

  UserSettingsModel? userSettingsModelFromEntity(UserSettings userSettings) {
    UserSettingsModel? model = _hiveBoxes.boxUserSettings?.values.last;
    model
      ?..connectedDevice = deviceModelFromEntity(userSettings.connectedDevice)
      ..listeningTransmissionChanges =
          userSettings.listeningTransmissionChanges;
    return model;
  }

  @override
  Future<Result<Exception, UserSettings>> create(
      UserSettings userSettings) async {
    try {
      UserSettings? userSettings = (await read()).fold(
        (failure) => null,
        (success) => success,
      );
      if (userSettings != null)
        return Success(userSettings);
      else {
        UserSettingsModel userSettingsModel = UserSettingsModel();
        await _hiveBoxes.boxUserSettings?.add(userSettingsModel);
        return Success(userSettingsModel.asEntity());
      }
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  Future<Result<Exception, bool>> delete() async {
    try {
      await _hiveBoxes.boxUserSettings?.clear();
      return Success(true);
    } catch (err) {
      return Failure(Exception(err));
    }
  }

  @override
  Future<Result<Exception, UserSettings>> read() async {
    try {
      List<UserSettingsModel>? userSettings =
          _hiveBoxes.boxUserSettings?.values.toList();
      if (userSettings != null && userSettings.isNotEmpty) {
        return Success(userSettings.first.asEntity());
      } else {
        return Success(UserSettings());
      }
    } catch (e) {
      return Failure(Exception(e));
    }
  }

  @override
  Future<Result<Exception, UserSettings>> update(
      UserSettings userSettings) async {
    try {
      UserSettingsModel? settingsModel =
          userSettingsModelFromEntity(userSettings);
      if (settingsModel != null) {
        await settingsModel.save();
        return Success(settingsModel.asEntity());
      } else {
        return Failure(Exception("null"));
      }
    } catch (e) {
      return Failure(Exception(e));
    }
  }
}
