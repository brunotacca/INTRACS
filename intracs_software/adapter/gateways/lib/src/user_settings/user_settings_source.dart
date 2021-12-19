import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

abstract class UserSettingsSource {
  Future<Result<Exception, UserSettings>> create(UserSettings userSettings);
  Future<Result<Exception, UserSettings>> read();
  Future<Result<Exception, UserSettings>> update(UserSettings userSettings);
  Future<Result<Exception, UserSettings>> delete();
}
