import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_app/core/themes/app_text_styles.dart';
import 'package:intracs_presenters/presenters.dart';

class ReceivedComputedDataDisplay
    with ChangeNotifier
    implements ReceivedComputedDataView {
  ComputedDataViewModel? computedDataViewModel;
  int numberOfGroups = 0;
  Set<int> groupsNames = {};
  Map<int, ComputedDataViewModel> lastComputedDataByGroup = {};
  Map<int, Widget> lastComputedDataWidget = {};

  @override
  Future<bool> display(Result<Exception, ComputedDataViewModel> result) async {
    result.fold(
      (failure) {
        computedDataViewModel = null;
      },
      (success) {
        // log("SUCCESS: " + success.toString());
        computedDataViewModel = success;
        if (groupsNames.add(success.group)) {
          numberOfGroups = groupsNames.length;
        }

        lastComputedDataByGroup.addAll({success.group: success});
        lastComputedDataWidget.addAll(
            {success.group: getTableWidgetFromComputedData(success.group)});
      },
    );
    notifyListeners();
    return true;
  }

  Widget getSensorTables() {
    if (numberOfGroups < 1)
      return Container();
    else {
      return SingleChildScrollView(
        child: Column(
          children: lastComputedDataWidget.values.toList(),
        ),
      );
    }
  }

  List<TableRow> getRowsFromComputedData(ComputedDataViewModel data) {
    List<TableRow> list = [];
    list.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child:
                    Text("Group:" + data.group.toString(), style: myTextBody2)),
          ),
          Center(child: Text(" Value ", style: myTextBody2)),
        ],
      ),
    );

    for (int i = 0; i < data.names.length; i++) {
      list.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(data.names[i], style: myTextBody2)),
            ),
            Center(child: Text(data.values[i].toString(), style: myTextBody2)),
          ],
        ),
      );
    }

    return list;
  }

  Widget getTableWidgetFromComputedData(int group) {
    ComputedDataViewModel computedData = lastComputedDataByGroup[group]!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        defaultColumnWidth: FlexColumnWidth(1.0),
        columnWidths: {0: FlexColumnWidth(3.0)},
        children: getRowsFromComputedData(computedData),
      ),
    );
  }
}
