/// Base exception class for all operational errors encountered across the application.
class AppException implements Exception {
  /// Human-readable error description suitable for user notifications or debug logging.
  final String message;

  /// HTTP or internal status code associated with the error, if available.
  final int? statusCode;

  /// Raw payload or server response payload for diagnostic context.
  final dynamic errorData;

  /// Creates an [AppException] instance.
  const AppException({
    required this.message,
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() => 'AppException(statusCode: $statusCode, message: $message)';
}

/// Thrown when connection timeout, DNS failure, or lack of internet connectivity occurs.
class NetworkException extends AppException {
  /// Creates a [NetworkException] instance.
  const NetworkException({required super.message, super.statusCode, super.errorData});
}

/// Thrown when an unauthenticated or expired token request is rejected with HTTP 401.
class UnauthorizedException extends AppException {
  /// Creates an [UnauthorizedException] instance.
  const UnauthorizedException({
    super.message = 'Unauthorized session. Please log in again.',
    super.statusCode = 401,
  });
}

/// Thrown when input validation fails or the server returns HTTP 400.
class BadRequestException extends AppException {
  /// Creates a [BadRequestException] instance.
  const BadRequestException({required super.message, super.statusCode = 400, super.errorData});
}

/// Thrown when a requested resource, item, or endpoint is not found (HTTP 404).
class NotFoundException extends AppException {
  /// Creates a [NotFoundException] instance.
  const NotFoundException({required super.message, super.statusCode = 404});
}

/// Thrown when the remote server encounters an internal failure (HTTP 500+).
class ServerException extends AppException {
  /// Creates a [ServerException] instance.
  const ServerException({
    super.message = 'Internal server error. Please try again later.',
    super.statusCode = 500,
  });
}
