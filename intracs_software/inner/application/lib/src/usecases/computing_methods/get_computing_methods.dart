import 'package:intracs_application/application.dart';

class GetComputingMethodsUseCase implements GetComputingMethods {
  final ComputingDataAccess computingDataAccess;
  final GetComputingMethodsOutput getComputingMethodsOutput;

  GetComputingMethodsUseCase(
      this.computingDataAccess, this.getComputingMethodsOutput);

  @override
  Future<bool> call() async {
    var resultMethods = await computingDataAccess.getComputingMethods();
    await resultMethods.fold(
      (failure) async => await getComputingMethodsOutput.show(Failure(failure)),
      (success) async => await getComputingMethodsOutput
          .show(Success(success.map((e) => e.parseAsOutputDTO()).toList())),
    );
    return true;
  }
}
