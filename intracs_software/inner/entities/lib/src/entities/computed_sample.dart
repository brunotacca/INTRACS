import 'package:intracs_entities/entities.dart';

/// A Computed Sample is a list of Computed Data that was created by a ComputingMethod
class ComputedSample {
  final ComputingMethod method;
  final List<ComputedData> sample;

  ComputedSample({
    required this.method,
    required this.sample,
  });
}
