import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intracs_app/core/themes/app_theme.dart';
import 'package:intracs_app/core/widgets/app_scaffold.dart';
import 'package:intracs_app/pages/method_selection/method_selection_controller.dart';

class MethodSelectionPage extends GetView<MethodSelectionController> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      blockOnPop: true,
      showDrawer: false,
      onlyTitle: true,
      title: 'PROCESSING_METHOD_PAGE_TITLE',
      body: Column(
        children: [
          Text("Choose a method to process the raw data after collecting it."),
          Expanded(
            child: FutureBuilder(
              future: controller.computingController.getComputingMethods(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 5),
                    itemCount: controller
                        .getComputingMethodsDisplay.computingMethods.length,
                    itemBuilder: (context, index) {
                      return methodEntryCard(index);
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget methodEntryCard(int index) {
    String uniqueName = controller
        .getComputingMethodsDisplay.computingMethods[index].uniqueName;
    String description = controller
        .getComputingMethodsDisplay.computingMethods[index].description;
    String inputs = controller
        .getComputingMethodsDisplay.computingMethods[index].inputNames
        .join(",");
    String outputs = controller
        .getComputingMethodsDisplay.computingMethods[index].inputNames
        .join(",");
    return Padding(
      padding: EdgeInsets.all(3),
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            Flexible(
              flex: 8,
              child: ListTile(
                title: Text(uniqueName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: appThemeData.textTheme.bodyText1,
                    ),
                    Text(
                      "Inputs: " + inputs,
                      style: appThemeData.textTheme.bodyText2,
                    ),
                    Text(
                      "Outputs: " + outputs,
                      style: appThemeData.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  await controller.selectMethod(uniqueName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
