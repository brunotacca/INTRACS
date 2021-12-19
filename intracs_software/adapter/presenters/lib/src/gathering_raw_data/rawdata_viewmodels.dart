import 'package:intracs_application/application.dart';

class RawDataViewModel {
  final DateTime? timestamp;
  final int? sensorNumber;
  final int? dataNumber;
  final XYZViewModel? accelerometer;
  final XYZViewModel? gyroscope;
  final XYZViewModel? magnetometer;

  RawDataViewModel({
    this.timestamp,
    this.sensorNumber,
    this.dataNumber,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
  });

  @override
  String toString() {
    return 'RawData(timestamp: $timestamp, sensorNumber: $sensorNumber, dataNumber: $dataNumber, accelerometer: $accelerometer, gyroscope: $gyroscope, magnetometer: $magnetometer)';
  }
}

class XYZViewModel {
  final String? x;
  final String? y;
  final String? z;

  XYZViewModel({
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  String toString() => '(x: $x, y: $y, z: $z)';
}

extension RawDataViewModelParsing on RawDataOutputDTO {
  RawDataViewModel parseAsViewModel() {
    return RawDataViewModel(
      timestamp: this.timestamp,
      sensorNumber: this.sensorNumber,
      dataNumber: this.dataNumber,
      accelerometer: XYZViewModel(
        x: this.accelerometer?.x?.toStringAsFixed(2),
        y: this.accelerometer?.y?.toStringAsFixed(2),
        z: this.accelerometer?.z?.toStringAsFixed(2),
      ),
      gyroscope: XYZViewModel(
        x: this.gyroscope?.x?.toStringAsFixed(2),
        y: this.gyroscope?.y?.toStringAsFixed(2),
        z: this.gyroscope?.z?.toStringAsFixed(2),
      ),
      magnetometer: XYZViewModel(
        x: this.magnetometer?.x?.toStringAsFixed(2),
        y: this.magnetometer?.y?.toStringAsFixed(2),
        z: this.magnetometer?.z?.toStringAsFixed(2),
      ),
    );
  }
}
