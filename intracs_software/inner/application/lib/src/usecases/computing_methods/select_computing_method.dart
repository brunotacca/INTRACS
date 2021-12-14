import 'package:intracs_application/application.dart';
import 'package:intracs_entities/entities.dart';

class SelectComputingMethodUseCase implements SelectComputingMethod {
  final ComputingMethodsDataAccess computingMethodsDataAccess;
  final SelectComputingMethodOutput selectComputingMethodOutput;

  SelectComputingMethodUseCase(
      this.computingMethodsDataAccess, this.selectComputingMethodOutput);

  @override
  Future<bool> call(ComputingMethodInputDTO params) async {
    var resultComputingMethod =
        await computingMethodsDataAccess.getComputingMethod(params.uniqueName);

    ComputingMethod? computingMethod = null;

    await resultComputingMethod.fold(
      (failure) async =>
          await selectComputingMethodOutput.call(Failure(failure)),
      (success) => computingMethod = success,
    );

    if (resultComputingMethod.isFailure() || computingMethod == null)
      return false;

    var selectedResult = await computingMethodsDataAccess
        .selectComputingMethod(computingMethod!);

    await selectedResult.fold(
      (failure) async =>
          await selectComputingMethodOutput.call(Failure(failure)),
      (success) async => await selectComputingMethodOutput
          .call(Success(success.parseAsOutputDTO())),
    );

    return true;
  }
}
