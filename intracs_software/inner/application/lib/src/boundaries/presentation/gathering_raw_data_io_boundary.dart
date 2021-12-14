import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class GatheringRawDataInfoOutputDTO {
  final bool isGatheringRawData;
  final double? rawDataGatheringRate;
  final int? secondsElapsedSinceStart;
  final int? rawDataGatheredAmount;
  GatheringRawDataInfoOutputDTO({
    required this.isGatheringRawData,
    this.rawDataGatheringRate,
    this.secondsElapsedSinceStart,
    this.rawDataGatheredAmount,
  });
}

class IsGatheringRawDataInputDTO {
  final bool isGatheringRawData;
  IsGatheringRawDataInputDTO({
    required this.isGatheringRawData,
  });
}

class RawDataOutputDTO {
  final DateTime? timestamp;
  final int? sensorNumber;
  final int? dataNumber;
  final XYZOutputDTO? accelerometer;
  final XYZOutputDTO? gyroscope;
  final XYZOutputDTO? magnetometer;

  RawDataOutputDTO({
    this.timestamp,
    this.sensorNumber,
    this.dataNumber,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
  });
}

class XYZOutputDTO {
  final double? x;
  final double? y;
  final double? z;

  XYZOutputDTO({
    required this.x,
    required this.y,
    required this.z,
  });
}

abstract class ToggleGatheringRawData implements InputBoundary<bool> {}

abstract class GatheringRawDataInfoOutput
    implements OutputBoundary<GatheringRawDataInfoOutputDTO> {}

abstract class GetRawDataGatheringInfo implements InputBoundaryNoParams {}

abstract class ReceivedRawDataOutput
    implements OutputBoundary<RawDataOutputDTO> {}

// Parsers
extension RawDataOutputParsing on RawData {
  RawDataOutputDTO parseAsOutputDTO() {
    return RawDataOutputDTO(
      timestamp: this.timestamp,
      sensorNumber: this.sensor.number,
      dataNumber: this.count,
      accelerometer: XYZOutputDTO(
        x: this.accelerometer?.x,
        y: this.accelerometer?.y,
        z: this.accelerometer?.z,
      ),
      gyroscope: XYZOutputDTO(
        x: this.gyroscope?.x,
        y: this.gyroscope?.y,
        z: this.gyroscope?.z,
      ),
      magnetometer: XYZOutputDTO(
        x: this.magnetometer?.x,
        y: this.magnetometer?.y,
        z: this.magnetometer?.z,
      ),
    );
  }
}
