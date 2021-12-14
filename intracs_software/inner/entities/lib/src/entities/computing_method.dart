/// The ComputingMethod identifies the computation to be made with the RawData.
/// This entity only definies the metadata for the computing method.
/// It doesn't defines the computation algorithm, since it's supposed to be added as a plugin.
class ComputingMethod {
  final String uniqueName;
  final String description;
  final List<String> inputNames;
  final List<String> outputNames;

  ComputingMethod({
    required this.uniqueName,
    required this.description,
    required this.inputNames,
    required this.outputNames,
  });
}
