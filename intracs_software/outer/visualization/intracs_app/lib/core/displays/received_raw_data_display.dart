import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_app/core/themes/app_text_styles.dart';
import 'package:intracs_presenters/presenters.dart';

class ReceivedRawDataDisplay
    with ChangeNotifier
    implements ReceivedRawDataView {
  RawDataViewModel? rawDataViewModel;
  int numberOfSensors = 0;
  Set<int> sensorsIds = {};
  Map<int, RawDataViewModel> lastRawDataOfSensor = {};
  Map<int, Widget> lastRawDataOfSensorTableWidget = {};

  @override
  Future<bool> display(Result<Exception, RawDataViewModel> result) async {
    result.fold(
      (failure) {
        rawDataViewModel = null;
      },
      (success) {
        rawDataViewModel = success;
        if (success.sensorNumber != null) {
          if (sensorsIds.add(success.sensorNumber!)) {
            numberOfSensors = sensorsIds.length;
          }

          lastRawDataOfSensor.addAll({success.sensorNumber!: success});
          lastRawDataOfSensorTableWidget.addAll({
            success.sensorNumber!:
                getTableWidgetFromSensorData(success.sensorNumber!)
          });
        }
      },
    );
    notifyListeners();
    return true;
  }

  Widget getSensorTables() {
    if (numberOfSensors < 1)
      return Container();
    else {
      return SingleChildScrollView(
        child: Column(
          children: lastRawDataOfSensorTableWidget.values.toList(),
        ),
      );
    }
  }

  Widget getTableWidgetFromSensorData(int sensorIndex) {
    RawDataViewModel rawData = lastRawDataOfSensor[sensorIndex]!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: FlexColumnWidth(1.0),
        columnWidths: {0: FlexColumnWidth(3.0)},
        children: [
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text("Sensor" + rawData.sensorNumber.toString(),
                        style: myTextBody2)),
              ),
              Center(child: Text(" X ", style: myTextBody2)),
              Center(child: Text(" Y ", style: myTextBody2)),
              Center(child: Text(" Z ", style: myTextBody2)),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Accelerometer", style: myTextBody2)),
              ),
              Center(
                  child: Text(rawData.accelerometer?.x.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.accelerometer?.y.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.accelerometer?.z.toString() ?? "",
                      style: myTextBody2)),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Gyroscope", style: myTextBody2)),
              ),
              Center(
                  child: Text(rawData.gyroscope?.x.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.gyroscope?.y.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.gyroscope?.z.toString() ?? "",
                      style: myTextBody2)),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Magnetometer", style: myTextBody2)),
              ),
              Center(
                  child: Text(rawData.magnetometer?.x.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.magnetometer?.y.toString() ?? "",
                      style: myTextBody2)),
              Center(
                  child: Text(rawData.magnetometer?.z.toString() ?? "",
                      style: myTextBody2)),
            ],
          ),
        ],
      ),
    );
  }
}
