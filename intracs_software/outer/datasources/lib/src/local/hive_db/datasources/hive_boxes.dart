import 'package:hive/hive.dart';
import 'package:intracs_datasources/datasources.dart';

class HiveBoxes {
  Box<UserSettingsModel>? boxUserSettings;
  Box<DeviceModel>? boxDevices;
  final String _hivePath;

  HiveBoxes(this._hivePath) {
    init();
  }

  Future init() async {
    Hive.init(_hivePath);

    Hive.registerAdapter<UserSettingsModel>(UserSettingsModelAdapter());
    Hive.registerAdapter<DeviceModel>(DeviceModelAdapter());

    if (await Hive.boxExists('userSettingsModels'))
      Hive.deleteBoxFromDisk('userSettingsModels');
    if (await Hive.boxExists('deviceModels'))
      Hive.deleteBoxFromDisk('deviceModels');

    boxUserSettings =
        await Hive.openBox<UserSettingsModel>('userSettingsModels');
    boxDevices = await Hive.openBox<DeviceModel>('deviceModels');
  }
}
