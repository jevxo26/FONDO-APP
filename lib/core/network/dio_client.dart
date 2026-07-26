import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../storage/secure_storage_service.dart';
import 'api_endpoints.dart';
import 'app_exception.dart';

final loggerProvider = Provider<Logger>((ref) => Logger());

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final logger = ref.watch(loggerProvider);
  return DioClient(storage: storage, logger: logger);
});

class DioClient {
  final SecureStorageService storage;
  final Logger logger;
  late final Dio dio;

  DioClient({required this.storage, required this.logger}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          logger.d('HTTP Request: [${options.method}] ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d('HTTP Response: [${response.statusCode}] ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e('HTTP Error: [${e.response?.statusCode}] ${e.requestOptions.path} - ${e.message}');
          final mappedError = _mapDioError(e);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: mappedError,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  AppException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException(message: 'Connection timeout. Please check your internet connection.');
    }

    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;
    String errorMessage = 'An unexpected error occurred.';

    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('message')) {
        errorMessage = responseData['message'].toString();
      } else if (responseData.containsKey('error')) {
        errorMessage = responseData['error'].toString();
      }
    }

    switch (statusCode) {
      case 400:
        return BadRequestException(message: errorMessage, errorData: responseData);
      case 401:
        return UnauthorizedException(message: errorMessage);
      case 404:
        return NotFoundException(message: errorMessage);
      case 500:
      case 502:
      case 503:
        return ServerException(message: errorMessage, statusCode: statusCode);
      default:
        return AppException(message: errorMessage, statusCode: statusCode, errorData: responseData);
    }
  }
}
