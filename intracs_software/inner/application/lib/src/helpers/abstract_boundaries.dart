import 'package:intracs_application/application.dart';

/// Strutuce of an executable class receiving parameters [Params]
/// Tipically used for implementing Use Cases that will output a result through an [OutputBoundary].
/// The return [bool] is meant to give a response to the caller about the method execution
/// If the method executed as it should, then [true]. If not, then [false].
abstract class InputBoundary<Params> {
  Future<bool> call(Params params);
}

/// Strutuce of an executable class without parameters
/// Tipically used for implementing Use Cases that will output a result through an [OutputBoundary].
/// The return [bool] is meant to give a response to the caller about the method execution
/// If the method executed as it should, then [true]. If not, then [false].
abstract class InputBoundaryNoParams {
  Future<bool> call();
}

/// Structure of an executable class to be called as Output with a Result.
/// The output can be called with an [Exception] or a [SuccessType].
/// The return [bool] is meant to give a response to the caller about the method execution
/// If the method executed as it should, then [true]. If not, then [false].
abstract class OutputBoundary<SuccessType> {
  Future<bool> call(Result<Exception, SuccessType> result);
}

/// Strutuce of an executable class receiving parameters
/// Tipically used for implementing Use Cases.
/// The Reversed acronym means that the input will not come from the user, but an event.
/// which means that an event (not the user) at the outer layer can call this.
/// The return [bool] is meant to give a response to the caller about the method execution
/// If the method executed as it should, then [true]. If not, then [false].
abstract class ReversedInputBoundary<SuccessType> {
  Future<bool> call(Result<Exception, SuccessType> result);
}
