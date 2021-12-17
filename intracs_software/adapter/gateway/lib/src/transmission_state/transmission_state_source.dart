import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

abstract class TransmissionStateSource {
  Future<Result<Exception, TransmissionState>> readTransmissionState();
}
