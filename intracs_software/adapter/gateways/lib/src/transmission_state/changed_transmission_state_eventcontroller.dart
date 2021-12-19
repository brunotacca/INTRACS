import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ChangedTransmissionStateEventController {
  final ChangedTransmissionState _changedTransmissionState;
  ChangedTransmissionStateEventController(this._changedTransmissionState);

  void register(Result<Exception, TransmissionState> result) {
    _changedTransmissionState.call(result);
  }
}
