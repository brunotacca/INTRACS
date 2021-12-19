import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/themes/app_text_styles.dart';
import 'package:intracs_app/core/themes/app_theme.dart';
import 'package:intracs_app/core/themes/widget_themes.dart';
import 'package:intracs_app/core/widgets/app_scaffold.dart';
import 'package:intracs_app/pages/data_monitor/data_monitor_controller.dart';
import 'package:intracs_app/pages/method_selection/method_selection_controller.dart';

class DataMonitorPage extends GetView<DataMonitorController> {
  final MethodSelectionController _methodSelectionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      blockOnPop: false,
      onlyTitle: true,
      showDrawer: false,
      title: 'DataMonitor',
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: Text(
                "Selected method: ${_methodSelectionController.getMethod()?.uniqueName}\n${_methodSelectionController.getMethod()?.description}"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: DefaultTabController(
                length: 2,
                child: new Scaffold(
                  appBar: new AppBar(
                    backgroundColor: appThemeData.backgroundColor,
                    elevation: 0,
                    leading: Container(),
                    flexibleSpace: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        new TabBar(
                          tabs: [
                            new Tab(text: "Raw"),
                            new Tab(text: "Computed"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      _tabOne(),
                      _tabTwo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                ElevatedButton(
                  style: elevatedBtnStyle,
                  child: Text("START"),
                  onPressed: () async {
                    await controller.startDataGathering();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: elevatedBtnStyle,
                  child: Text("STOP"),
                  onPressed: () async {
                    await controller.stopDataGathering();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabOne() {
    return SingleChildScrollView(
      child: Column(
        children: [
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

  Widget _tabTwo() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () {
              if (controller.computedDataCounter.value > -1) {
                return Column(
                  children: [
                    Text(
                      controller.computedDataCounter.value.toString() +
                          " (" +
                          controller.computedDataPerSecond.value
                              .toStringAsFixed(2) +
                          "/s)",
                      style: myTextBody,
                    ),
                    controller.receivedComputedDataDisplay.getSensorTables(),
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
