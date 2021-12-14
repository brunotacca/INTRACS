import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ComputingMethodInputDTO {
  final String uniqueName;
  ComputingMethodInputDTO({
    required this.uniqueName,
  });
}

class ComputingMethodOutputDTO {
  final String uniqueName;
  final String description;
  final List<String> inputNames;
  final List<String> outputNames;
  ComputingMethodOutputDTO({
    required this.uniqueName,
    required this.description,
    required this.inputNames,
    required this.outputNames,
  });
}

class ComputedDataOutputDTO {
  final DateTime timestamp;
  final int group;
  final int count;
  final List<String> names;
  final List<double?> values;

  ComputedDataOutputDTO({
    required this.timestamp,
    required this.group,
    required this.count,
    required this.names,
    required this.values,
  });
}

class IsComputingRawDataOutputDTO {
  final bool isComputingRawData;
  IsComputingRawDataOutputDTO(this.isComputingRawData);
}

abstract class GetComputingMethods implements InputBoundaryNoParams {}

abstract class GetComputingMethodsOutput
    implements OutputBoundary<List<ComputingMethodOutputDTO>> {}

abstract class SelectComputingMethod
    implements InputBoundary<ComputingMethodInputDTO> {}

abstract class SelectComputingMethodOutput
    implements OutputBoundary<ComputingMethodOutputDTO> {}

abstract class IsComputingRawDataOutput
    implements OutputBoundary<IsComputingRawDataOutputDTO> {}

abstract class StartComputingRawData implements InputBoundaryNoParams {}

abstract class StopComputingRawData implements InputBoundaryNoParams {}

abstract class ReceivedComputedDataOutput
    implements OutputBoundary<ComputedDataOutputDTO> {}

extension ComputingMethodParsing on ComputingMethod {
  ComputingMethodOutputDTO parseAsOutputDTO() {
    return ComputingMethodOutputDTO(
      uniqueName: this.uniqueName,
      description: this.description,
      inputNames: this.inputNames,
      outputNames: this.outputNames,
    );
  }
}

extension ComputingRawDataOutputParsing on ComputedData {
  ComputedDataOutputDTO parseAsOutputDTO() {
    return ComputedDataOutputDTO(
      timestamp: this.timestamp,
      count: this.count,
      group: this.group,
      names: this.names,
      values: this.values,
    );
  }
}
