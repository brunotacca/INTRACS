/// Simplified version of DartZ/either
/// Made for personal use and simple error handling through different architecture layers
/// Easily understandable and maintainable.

/// Union of two generic types.
/// Instances of [Result] are either an instance of [Failure] or [Success].
///
/// [Failure] is [Exception] and often used for "failure" cases.
/// [Success] is often used for "success" cases.
abstract class Result<Exception, S> {
  const Result();

  /// Fold: Decompose into two functions of each value: [Failure] and [Success].
  T fold<T>(T ifFailure(Exception failure), T ifSuccess(S success));

  /// Check if is instance of [Failure].
  /// If fold from child is the first fold, then it's [Failure]
  bool isFailure() => fold((_) => true, (_) => false);

  /// Check if is instance of [Success]
  /// If fold from child is the second fold, then it's [Success]
  bool isSuccess() => fold((_) => false, (_) => true);

  @override
  String toString() => fold((f) => 'Failure($f)', (s) => 'Success($s)');
}

/// [Failure] case of [Result]
class Failure<Exception, S> extends Result<Exception, S> {
  final Exception _f;
  const Failure(this._f);
  Exception get value => _f;
  @override
  B fold<B>(B ifFailure(Exception f), B ifSuccess(S s)) => ifFailure(_f);
  @override
  bool operator ==(other) => other is Failure && other._f == _f;
  @override
  int get hashCode => _f.hashCode;
}

/// [Success] case of [Result]
class Success<Exception, S> extends Result<Exception, S> {
  final S _s;
  const Success(this._s);
  S get value => _s;
  @override
  B fold<B>(B ifFailure(Exception f), B ifSuccess(S s)) => ifSuccess(_s);
  @override
  bool operator ==(other) => other is Success && other._s == _s;
  @override
  int get hashCode => _s.hashCode;
}
