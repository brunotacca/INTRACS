import 'package:intracs_entities/entities.dart';

/// Raw Data contains the all data related from the IMU sensor
/// It also identifies the sensor, the timestamp and a counter.
class RawData {
  final DateTime timestamp;
  final Sensor sensor;
  final int count;
  final XYZ? accelerometer;
  final XYZ? gyroscope;
  final XYZ? magnetometer;

  RawData({
    required this.timestamp,
    required this.sensor,
    required this.count,
    this.accelerometer,
    this.gyroscope,
    this.magnetometer,
  });

  @override
  String toString() {
    return 'RawData(timestamp: $timestamp, sensor: $sensor, count: $count, accelerometer: $accelerometer, gyroscope: $gyroscope, magnetometer: $magnetometer)';
  }
}
