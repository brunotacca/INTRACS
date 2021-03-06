import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class DevicesRepository extends DevicesDataAccess {
  final DevicesSource _devicesDataSource;
  DevicesRepository(this._devicesDataSource);

  @override
  Future<Result<Exception, Device>> connectToDevice(Device device) async {
    try {
      return await _devicesDataSource.connectToDevice(device);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  Future<Result<Exception, List<Device>>> getDevicesAvailable() async {
    try {
      return await _devicesDataSource.readAllDevicesAvailable();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
