import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class UserSettingsRepository extends UserSettingsDataAccess {
  final UserSettingsSource userSettingsSource;
  UserSettingsRepository(this.userSettingsSource);

  @override
  Future<Result<Exception, UserSettings>> getUserSettings() async {
    try {
      return await userSettingsSource.read();
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, UserSettings>> setUserSettings(
      UserSettings userSettings) async {
    try {
      Result<Exception, UserSettings> result = await userSettingsSource.read();
      UserSettings? actualUserSettings;
      await result.fold(
        (failure) => null,
        (success) => actualUserSettings = success,
      );

      if (result.isFailure())
        return result;
      else {
        if (actualUserSettings == null) {
          // create
          return await userSettingsSource.create(userSettings);
        } else {
          // update
          return await userSettingsSource.update(userSettings);
        }
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
