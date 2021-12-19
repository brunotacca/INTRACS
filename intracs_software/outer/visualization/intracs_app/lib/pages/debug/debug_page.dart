import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/themes/app_text_styles.dart';
import 'package:intracs_app/core/themes/widget_themes.dart';
import 'package:intracs_app/core/widgets/app_scaffold.dart';
import 'package:intracs_app/pages/debug/debug_controller.dart';
import 'package:intracs_controllers/controllers.dart';

class DebugPage extends GetView<DebugController> {
  // final DeviceSender _deviceSender = GetIt.I<DeviceSender>();
  final GatheringRawDataController _gatheringRawDataController = GetIt.I();

  Future _startGathering() async {
    await _gatheringRawDataController.startGatheringRawData();
  }

  Future _stopGathering() async {
    await _gatheringRawDataController.stopGatheringRawData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      blockOnPop: false,
      title: 'RAW_DATA_GATHERING_PAGE_TITLE',
      body: Column(
        children: [
          Text("""
      Raw Data Gathering
      """),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: elevatedBtnStyle,
                child: Text("START"),
                onPressed: () async {
                  await _startGathering();
                },
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: elevatedBtnStyle,
                child: Text("STOP"),
                onPressed: () async {
                  await _stopGathering();
                },
              ),
            ],
          ),
          Obx(
            () {
              if (controller.dataCounter.value > -1) {
                return Column(
                  children: [
                    Text(
                      controller.dataCounter.value.toString() +
                          " (" +
                          controller.dataPerSecond.value.toStringAsFixed(2) +
                          "/s)",
                      style: myTextBody,
                    ),
                    controller.receivedRawDataDisplay.getSensorTables(),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
