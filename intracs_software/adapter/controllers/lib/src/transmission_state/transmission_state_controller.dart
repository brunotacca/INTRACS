import 'package:intracs_application/application.dart';

class TransmissionStateController {
  final GetTransmissionState _getTransmissionState;
  TransmissionStateController(this._getTransmissionState);

  Future<bool> getTransmissionState() async {
    return await _getTransmissionState.call();
  }
}
