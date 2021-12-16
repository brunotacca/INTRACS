import 'package:intracs_application/application.dart';

class StopComputingRawDataUseCase implements StopComputingRawData {
  final ComputingDataAccess computingDataAccess;
  final IsComputingRawDataOutput isComputingRawDataOutput;
  StopComputingRawDataUseCase(
      this.computingDataAccess, this.isComputingRawDataOutput);

  @override
  Future<bool> call() async {
    if (!(await computingDataAccess.isComputingRawData())) {
      await isComputingRawDataOutput
          .call(Success(IsComputingRawDataOutputDTO(false)));
    } else {
      var result = await computingDataAccess.stopComputingRawData();
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
