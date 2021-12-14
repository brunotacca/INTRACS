import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

/// Defines the methods to manage the data needed
/// for the use cases using [UserSettings]
abstract class UserSettingsDataAccess {
  Future<Result<Exception, UserSettings>> getUserSettings();
  Future<Result<Exception, UserSettings>> setUserSettings(
      UserSettings userSettings);
}
