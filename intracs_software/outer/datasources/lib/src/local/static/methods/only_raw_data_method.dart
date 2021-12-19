import 'package:intracs_gateways/gateways.dart';
import 'package:intracs_entities/entities.dart';

final OnlyRawData onlyRawData = OnlyRawData();

class OnlyRawData extends ComputingMethodWithEngine {
  @override
  ComputingMethod get method => ComputingMethod(
        uniqueName: "OnlyRawData",
        description: "No processing",
        inputNames: [
          "None",
        ],
        outputNames: [
          "None",
        ],
      );

  @override
  Future<ComputedData> compute(RawData rawData) async {
    return ComputedData(
      timestamp: DateTime.now(),
      group: -1,
      count: -1,
      names: [""],
      values: [-1],
    );
  }
}
