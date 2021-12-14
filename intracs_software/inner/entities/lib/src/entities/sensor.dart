/// A Sensor is a piece of hardware also known as IMU (Inertial Measurement Unit).
/// It can contain different inertial sensors, they usually are
/// An accelerometer, a gyroscope and a magnetometer.
/// Each of these sensors usually have 3 axis each, so an IMU with all 3 sensors
/// is known as a 9 axis IMU.
class Sensor {
  final String name;
  final int number;
  final String? description;
  final String? version;

  Sensor({
    required this.name,
    required this.number,
    this.description,
    this.version,
  });
}
