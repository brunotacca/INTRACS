import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

abstract class DevicesSource {
  Future<Result<Exception, List<Device>>> readAllDevicesAvailable();
  Future<Result<Exception, Device>> connectToDevice(Device device);
}
