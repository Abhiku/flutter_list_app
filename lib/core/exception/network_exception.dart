import 'package:dio/dio.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  NetworkException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException(
          message: 'Connection timeout',
          error: error,
        );
      case DioExceptionType.sendTimeout:
        return NetworkException(
          message: 'Send timeout',
          error: error,
        );
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Receive timeout',
          error: error,
        );
      case DioExceptionType.badResponse:
        return NetworkException(
          message: _handleErrorMessage(error.response),
          statusCode: error.response?.statusCode,
          error: error,
        );
      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request cancelled',
          error: error,
        );
      default:
        return NetworkException(
          message: 'Network error occurred',
          error: error,
        );
    }
  }

  static String _handleErrorMessage(Response? response) {
    if (response?.data != null && response?.data['message'] != null) {
      return response?.data['message'];
    }
    switch (response?.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}
