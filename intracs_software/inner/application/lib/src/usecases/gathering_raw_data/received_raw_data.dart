import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class ReceivedRawDataUseCase implements ReceivedRawData {
  final ReceivedRawDataOutput output;
  ReceivedRawDataUseCase(this.output);

  @override
  Future<bool> call(Result<Exception, RawData> result) async {
    dynamic r = await result.fold(
      (failure) async => await output.call(Failure(failure)),
      (success) async => await output.call(Success(success.parseAsOutputDTO())),
    );
    return (r != null);
  }
}
