import 'package:intracs_gateway/gateway.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class TransmissionStateRepository extends TransmissionStateDataAccess {
  final TransmissionStateSource transmissionStateDataSource;
  TransmissionStateRepository(this.transmissionStateDataSource);

  @override
  Future<Result<Exception, TransmissionState>> getTransmissionState() async {
    try {
      return await transmissionStateDataSource.readTransmissionState();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
