class AppError {
  AppError({required this.code, required this.message, this.traceId});

  final AppErrorCode code;
  final String message;
  final String? traceId;

  @override
  String toString() => 'AppError(code: ' + code.name + ', message: ' + message + ')';
}

enum AppErrorCode { network, timeout, validation, unknown }
