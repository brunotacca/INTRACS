import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedRawDataUseCase implements ReceivedRawData {
  final ComputingDataAccess computingDataAccess;
  final ReceivedRawDataOutput output;
  ReceivedRawDataUseCase(this.computingDataAccess, this.output);

  @override
  Future<bool> call(Result<Exception, RawData> result) async {
    // send the raw data to the output
    dynamic r = await result.fold(
      (failure) async => await output.show(Failure(failure)),
      (success) async {
        await output.show(Success(success.parseAsOutputDTO()));

        // verify if the application is computing rawdata and act accordingly
        await computingDataAccess.isComputingRawData().then(
          (isComputing) {
            if (isComputing) {
              // register that a new raw data was received
              computingDataAccess.registerNewRawData(success);
            }
          },
        );
      },
    );

    return (r != null);
  }
}
