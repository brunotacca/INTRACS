import 'package:flutter/widgets.dart';
import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class TransmissionStateDisplay
    with ChangeNotifier
    implements TransmissionStateView {
  TransmissionStateViewModel? transmissionStateDisplayModel;
  @override
  Future<bool> display(
      Result<Exception, TransmissionStateViewModel> result) async {
    result.fold(
      (failure) {
        print(failure);
        transmissionStateDisplayModel = null;
      },
      (success) {
        print(success);
        transmissionStateDisplayModel = success;
      },
    );
    notifyListeners();
    return true;
  }
}
