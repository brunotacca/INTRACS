import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

/// Defines the methods to manage the data needed
/// for the use cases using [Device]
abstract class DevicesDataAccess {
  Future<Result<Exception, List<Device>>> getDevicesAvailable();
  Future<Result<Exception, Device>> connectToDevice(Device device);
}
