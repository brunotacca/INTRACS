import 'package:intracs_application/application.dart';

class ComputingMethodViewModel {
  final String uniqueName;
  final String description;
  final List<String> inputNames;
  final List<String> outputNames;
  ComputingMethodViewModel({
    required this.uniqueName,
    required this.description,
    required this.inputNames,
    required this.outputNames,
  });
}

extension ComputingMethodViewModelParser on ComputingMethodOutputDTO {
  ComputingMethodViewModel parseAsViewModel() {
    return ComputingMethodViewModel(
      uniqueName: this.uniqueName,
      description: this.description,
      inputNames: this.inputNames,
      outputNames: this.outputNames,
    );
  }
}

class ComputedDataViewModel {
  final DateTime timestamp;
  final int group;
  final int count;
  final List<String> names;
  final List<String> values;

  ComputedDataViewModel({
    required this.timestamp,
    required this.group,
    required this.count,
    required this.names,
    required this.values,
  });

  @override
  String toString() {
    return 'ComputedDataViewModel(timestamp: $timestamp, group: $group, count: $count, names: $names, values: $values)';
  }
}

extension ComputingDataViewModelParser on ComputedDataOutputDTO {
  ComputedDataViewModel parseAsViewModel() {
    return ComputedDataViewModel(
      timestamp: this.timestamp,
      group: this.group,
      count: this.count,
      names: this.names,
      values: this.values.map((e) => e?.toStringAsFixed(2) ?? "NULL").toList(),
    );
  }
}

class IsComputingRawDataViewModel extends IsComputingRawDataOutputDTO {
  IsComputingRawDataViewModel(bool isComputingRawData)
      : super(isComputingRawData);
}
