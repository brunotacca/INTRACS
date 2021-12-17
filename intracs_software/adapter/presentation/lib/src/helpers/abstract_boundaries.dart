import 'package:intracs_application/application.dart';

/// Structure of an executable class to be called as Output with a Result.
/// The output can be called with an [Exception] or a [SuccessType].
/// The return [bool] is meant to give a response to the caller about the method execution
/// If the method executed as it should, then [true]. If not, then [false].
abstract class OutputViewBoundary<SuccessType> {
  Future<bool> display(Result<Exception, SuccessType> result);
}
