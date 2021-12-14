import 'package:intracs_application/application.dart';

class StopComputingRawDataUseCase implements StopComputingRawData {
  final ComputingMethodsDataAccess computingMethodsDataAccess;
  final IsComputingRawDataOutput isComputingRawDataOutput;
  StopComputingRawDataUseCase(
      this.computingMethodsDataAccess, this.isComputingRawDataOutput);

  @override
  Future<bool> call() async {
    if (!(await computingMethodsDataAccess.isComputingRawData())) {
      await isComputingRawDataOutput
          .call(Success(IsComputingRawDataOutputDTO(false)));
    } else {
      var result = await computingMethodsDataAccess.stopComputingRawData();
      await result.fold(
        (failure) async =>
            await isComputingRawDataOutput.call(Failure(failure)),
        (success) async => await isComputingRawDataOutput
            .call(Success(IsComputingRawDataOutputDTO(false))),
      );
    }
    return true;
  }
}
