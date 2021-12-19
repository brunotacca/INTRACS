import 'dart:developer';

import 'package:get/state_manager.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class GatheringRawDataInfoDisplay extends GetxController
    implements GatheringRawDataInfoView {
  var isGatheringRawData = false.obs;
  GatheringRawDataInfoViewModel? viewModel;

  @override
  Future<bool> display(
      Result<Exception, GatheringRawDataInfoViewModel> result) async {
    result.fold(
      (failure) => log("FAILURE: " + failure.toString()),
      (success) {
        viewModel = success;
        isGatheringRawData.value = success.isGatheringRawData;
      },
    );
    return true;
  }
}
