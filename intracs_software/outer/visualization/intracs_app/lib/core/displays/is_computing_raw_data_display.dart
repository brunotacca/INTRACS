import 'package:intracs_application/application.dart';
import 'package:intracs_presenters/presenters.dart';

class IsComputingRawDataDisplay implements IsComputingRawDataView {
  bool computingRawData = false;

  @override
  Future<bool> display(
      Result<Exception, IsComputingRawDataViewModel> result) async {
    result.fold(
      (failure) => null,
      (success) => computingRawData = success.isComputingRawData,
    );
    return true;
  }
}
