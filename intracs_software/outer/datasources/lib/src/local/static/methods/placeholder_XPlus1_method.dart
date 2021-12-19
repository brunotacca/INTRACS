import 'dart:async';

import 'package:intracs_entities/entities.dart';
import 'package:intracs_gateways/gateways.dart';

final PlaceholderXPlus1 placeholderXPlus1 = PlaceholderXPlus1();

class PlaceholderXPlus1 extends ComputingMethodWithEngine {
  @override
  ComputingMethod get method => ComputingMethod(
        uniqueName: "PlaceholderXPlus1",
        description: "Add 1 to X",
        inputNames: ["accX"],
        outputNames: ["accX"],
      );

  @override
  Future<ComputedData> compute(RawData rawData) async {
    return ComputedData(
      timestamp: DateTime.now(),
      group: rawData.sensor.number,
      count: rawData.count,
      names: [
        "accX",
      ],
      values: [
        rawData.accelerometer!.x! + 1,
      ],
    );
  }
}
