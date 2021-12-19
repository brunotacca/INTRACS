import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class TransmissionStateRepository extends TransmissionStateDataAccess {
  final TransmissionStateSource _transmissionStateDataSource;
  TransmissionStateRepository(this._transmissionStateDataSource);

  @override
  Future<Result<Exception, TransmissionState>> getTransmissionState() async {
    try {
      return await _transmissionStateDataSource.readTransmissionState();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
