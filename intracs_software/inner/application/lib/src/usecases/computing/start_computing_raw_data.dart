import 'package:intracs_application/application.dart';

class StartComputingRawDataUseCase implements StartComputingRawData {
  final ComputingDataAccess computingDataAccess;
  final IsComputingRawDataOutput isComputingRawDataOutput;
  StartComputingRawDataUseCase(
      this.computingDataAccess, this.isComputingRawDataOutput);

  @override
  Future<bool> call() async {
    if (await computingDataAccess.isComputingRawData()) {
      await isComputingRawDataOutput
          .show(Success(IsComputingRawDataOutputDTO(true)));
    } else {
      var result = await computingDataAccess.startComputingRawData();
      await result.fold(
        (failure) async =>
            await isComputingRawDataOutput.show(Failure(failure)),
        (success) async => await isComputingRawDataOutput
            .show(Success(IsComputingRawDataOutputDTO(true))),
      );
    }
    return true;
  }
}
