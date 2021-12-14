/// The TransmissionState is litteraly what it is.
/// It can be bluetooth/wifi/usb/whatever.
/// The state indicates the different status possibilities of the transmission.
class TransmissionState {
  final TransmissionStateEnum state;
  TransmissionState(this.state);

  bool get isUnknown => state == TransmissionStateEnum.unknown;
  bool get isUnavailable => state == TransmissionStateEnum.unavailable;
  bool get isAuthorized => state != TransmissionStateEnum.unauthorized;
  bool get isOn => state == TransmissionStateEnum.turnedOn;
  bool get isReady => (!isUnavailable && isOn && isAuthorized);
  bool get isConnected => isReady && state == TransmissionStateEnum.connected;
  bool get isTransmitting =>
      isConnected && state == TransmissionStateEnum.transmitting;
}

enum TransmissionStateEnum {
  unknown,
  unavailable,
  unauthorized,
  turnedOn,
  turnedOff,
  connected,
  transmitting,
}
