class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode, super.errorData});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized session. Please log in again.', super.statusCode = 401});
}

class BadRequestException extends AppException {
  const BadRequestException({required super.message, super.statusCode = 400, super.errorData});
}

class NotFoundException extends AppException {
  const NotFoundException({required super.message, super.statusCode = 404});
}

class ServerException extends AppException {
  const ServerException({super.message = 'Internal server error. Please try again later.', super.statusCode = 500});
}
