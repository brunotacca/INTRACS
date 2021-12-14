import 'package:intracs_application/application.dart';

class GetComputingMethodsUseCase implements GetComputingMethods {
  final ComputingMethodsDataAccess computingMethodsDataAccess;
  final GetComputingMethodsOutput getComputingMethodsOutput;

  GetComputingMethodsUseCase(
      this.computingMethodsDataAccess, this.getComputingMethodsOutput);

  @override
  Future<bool> call() async {
    var resultMethods = await computingMethodsDataAccess.getComputingMethods();
    await resultMethods.fold(
      (failure) async => await getComputingMethodsOutput.call(Failure(failure)),
      (success) async => await getComputingMethodsOutput
          .call(Success(success.map((e) => e.parseAsOutputDTO()).toList())),
    );
    return true;
  }
}
