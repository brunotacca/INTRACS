import 'package:intracs_application/application.dart';

class ToggleGatheringRawDataUseCase implements ToggleGatheringRawData {
  final GatheringRawDataDataAccess dataAccess;
  final GatheringRawDataInfoOutput output;
  ToggleGatheringRawDataUseCase(this.dataAccess, this.output);

  @override
  Future<bool> call(bool isGatheringRawData) async {
    var result;

    // Start if toggled to true
    if (isGatheringRawData) {
      result = await dataAccess.startGatheringRawData();
    } else
    // Stop if toggled to false
    if (!isGatheringRawData) {
      result = await dataAccess.stopGatheringRawData();
    } else {
      await output.call(Failure(Exception("UNKNOWN_ERROR")));
      return false;
    }

    dynamic r = await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async => await output.call(
          Success(GatheringRawDataInfoOutputDTO(isGatheringRawData: success))),
    );

    return (r != null);
  }
}
