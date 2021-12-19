import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class SelectComputingMethodDisplay implements SelectComputingMethodView {
  ComputingMethodViewModel? selectedComputingMethod;

  @override
  Future<bool> display(
      Result<Exception, ComputingMethodViewModel> result) async {
    selectedComputingMethod = result.fold(
      (failure) => null,
      (success) => success,
    );
    return true;
  }
}
