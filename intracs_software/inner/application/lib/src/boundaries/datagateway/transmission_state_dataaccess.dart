import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

/// Defines the methods to manage the data needed
/// for the use cases using [TransmissionState]
abstract class TransmissionStateDataAccess {
  Future<Result<Exception, TransmissionState>> getTransmissionState();
}

/// If the TransmissionState changes by some external factor this use case is called.
abstract class ChangedTransmissionState
    implements ReversedInputBoundary<TransmissionState> {}
