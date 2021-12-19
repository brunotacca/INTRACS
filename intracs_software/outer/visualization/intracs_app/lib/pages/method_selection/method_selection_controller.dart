import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intracs_app/core/displays/get_computing_methods_display.dart';
import 'package:intracs_app/core/displays/select_computing_method_display.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_controllers/controllers.dart';
import 'package:intracs_presenters/presenters.dart';

class MethodSelectionController extends GetxController {
  static MethodSelectionController get to => Get.find();
  final GetComputingMethodsDisplay getComputingMethodsDisplay = GetIt.I();
  final SelectComputingMethodDisplay selectComputingMethodDisplay = GetIt.I();
  final ComputingController computingController =
      GetIt.I<ComputingController>();
  ComputingMethodInputDTO? selectedMethodUniqueName;

  Future selectMethod(String uniqueName) async {
    selectedMethodUniqueName = ComputingMethodInputDTO(uniqueName: uniqueName);
    await computingController.selectComputingMethod(selectedMethodUniqueName!);
    if (selectComputingMethodDisplay.selectedComputingMethod != null) {
      log("SELECTED: " +
          selectComputingMethodDisplay.selectedComputingMethod!.uniqueName);
      Get.toNamed('/data_monitor');
    } // else output error?
    return;
  }

  ComputingMethodViewModel? getMethod() {
    return selectComputingMethodDisplay.selectedComputingMethod;
  }
}
