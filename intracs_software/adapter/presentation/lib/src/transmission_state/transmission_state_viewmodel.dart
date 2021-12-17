import 'package:intracs_application/application.dart';

class TransmissionStateViewModel {
  final bool? unknown;
  final bool? unavailable;
  final bool? authorized;
  final bool? turnedOn;
  final bool? ready;
  final bool? connected;
  final bool? transmitting;
  TransmissionStateViewModel({
    this.unknown,
    this.unavailable,
    this.authorized,
    this.turnedOn,
    this.ready,
    this.connected,
    this.transmitting,
  });
  String? get unknownText => unknown == true ? "UNKNOWN" : null;
  String? get unavailableText => unavailable == true ? "UNAVAILABLE" : null;
  String? get unavailableTextDesc =>
      unavailable == true ? "UNAVAILABLE_DESC" : null;
  String get authorizedText =>
      authorized == true ? "AUTHORIZED" : "NOT_AUTHORIZED";
  String get turnedOnText => turnedOn == true ? "TURNED_ON" : "TURNED_OFF";
  String get readyText => ready == true ? "READY" : "NOT_READY";
  String get connectedText => connected == true ? "CONNECTED" : "NOT_CONNECTED";
  String get transmittingText => transmitting == true ? "TRANSMITTING" : "IDLE";
}

extension TransmissionStateDisplayModelParsing on TransmissionStateOutputDTO {
  TransmissionStateViewModel parseAsDisplayModel() {
    return TransmissionStateViewModel(
      authorized: this.authorized,
      connected: this.connected,
      ready: this.ready,
      transmitting: this.transmitting,
      turnedOn: this.turnedOn,
      unavailable: this.unavailable,
      unknown: this.unavailable,
    );
  }
}
