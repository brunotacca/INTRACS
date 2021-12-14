import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedComputedDataUseCase implements ReceivedComputedData {
  final ReceivedComputedDataOutput output;
  ReceivedComputedDataUseCase(this.output);

  @override
  Future<bool> call(Result<Exception, ComputedData> result) async {
    await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async => await output.call(Success(success.parseAsOutputDTO())),
    );
    return true;
  }
}
