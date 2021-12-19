import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class GetComputingMethodsDisplay implements GetComputingMethodsView {
  List<ComputingMethodViewModel> computingMethods = [];

  @override
  Future<bool> display(
      Result<Exception, List<ComputingMethodViewModel>> result) async {
    computingMethods.clear();
    result.fold(
      (failure) => null,
      (success) => computingMethods.addAll(success),
    );
    return true;
  }
}
