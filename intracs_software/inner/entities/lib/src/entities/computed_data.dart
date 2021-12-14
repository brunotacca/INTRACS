/// A ComputedData is a Raw Data that was computed through a ComputingMethod.
/// The RawData is transformed into other variables, which is defined by names and values.
/// It's also possible distinguish between ComputedData groups
/// e.g. with multiple IMUs you can use them all to output the values into 1 group, or many groups.
class ComputedData {
  final DateTime timestamp;
  // Can group data when there are multiples grouped outputs. (e.g. 2 IMU sensors calculating pose separately)
  final int group;
  // Data count
  final int count;
  // ex: [velocityX, velocityY, velocityZ, positionX/Y/Z, ...]
  final List<String> names;
  // ex: [3.12, 0.50, 0.00, ...]
  final List<double?> values;

  ComputedData({
    required this.timestamp,
    required this.group,
    required this.count,
    required this.names,
    required this.values,
  });
}
