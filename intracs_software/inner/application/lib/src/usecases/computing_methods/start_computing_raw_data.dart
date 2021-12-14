import 'package:intracs_application/application.dart';

class StartComputingRawDataUseCase implements StartComputingRawData {
  final ComputingMethodsDataAccess computingMethodsDataAccess;
  final IsComputingRawDataOutput isComputingRawDataOutput;
  StartComputingRawDataUseCase(
      this.computingMethodsDataAccess, this.isComputingRawDataOutput);

  @override
  Future<bool> call() async {
    if (await computingMethodsDataAccess.isComputingRawData()) {
      await isComputingRawDataOutput
          .call(Success(IsComputingRawDataOutputDTO(true)));
    } else {
      var result = await computingMethodsDataAccess.startComputingRawData();
      await result.fold(
        (failure) async =>
            await isComputingRawDataOutput.call(Failure(failure)),
        (success) async => await isComputingRawDataOutput
            .call(Success(IsComputingRawDataOutputDTO(true))),
      );
    }
    return true;
  }
}
