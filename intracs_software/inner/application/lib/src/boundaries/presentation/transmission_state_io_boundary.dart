import 'package:intracs_entities/entities.dart';

import 'package:intracs_application/application.dart';

/// The representation of a Transmission State.
/// Contains attributes of interest to be externalized to outer layers.
class TransmissionStateOutputDTO {
  final bool? unknown;
  final bool? unavailable;
  final bool? authorized;
  final bool? turnedOn;
  final bool? ready;
  final bool? connected;
  final bool? transmitting;
  TransmissionStateOutputDTO({
    this.unknown,
    this.unavailable,
    this.authorized,
    this.turnedOn,
    this.ready,
    this.connected,
    this.transmitting,
  });
}

/// Use case to get the actual TransmissionState
abstract class GetTransmissionState implements InputBoundaryNoParams {}

/// Output for the use case GetTransmissionState
abstract class GetTransmissionStateOutput
    implements OutputBoundary<TransmissionStateOutputDTO> {}

/// The Output for the ChangedTransmissionState use case
abstract class ChangedTransmissionStateOutput
    implements OutputBoundary<TransmissionStateOutputDTO> {}

/// Let the application decides if it will keep receiving
/// transmission state changes through the ChangedTransmissionState use case
/// TODO
abstract class ToggleListeningTransmissionStateChanges
    implements InputBoundary<bool> {}

// Parsers
extension TransmissionStateOutputParsing on TransmissionState {
  TransmissionStateOutputDTO parseAsOutputDTO() {
    return TransmissionStateOutputDTO(
      authorized: this.isAuthorized,
      connected: this.isConnected,
      ready: this.isReady,
      transmitting: this.isTransmitting,
      turnedOn: this.isOn,
      unavailable: this.isUnavailable,
      unknown: this.isUnknown,
    );
  }
}
