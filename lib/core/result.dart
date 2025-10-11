import 'errors.dart';

sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(AppError error) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    }
    return failure((self as Failure<T>).error);
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => this is Success<T> ? (this as Success<T>).data : null;
  AppError? get error => this is Failure<T> ? (this as Failure<T>).error : null;
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppError error;
}
