/// A simple entity representing 3 axis of an inertial sensor
class XYZ {
  final double? x;
  final double? y;
  final double? z;

  XYZ({
    this.x,
    this.y,
    this.z,
  });

  @override
  String toString() => 'XYZ(x: $x, y: $y, z: $z)';
}
