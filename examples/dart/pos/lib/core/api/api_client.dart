// lib/core/api/api_client.dart
// HTTP client service using Dio for API communications. Provides singleton instance with configured base URL, timeouts, and request/response interceptors for debugging and authentication.
// Usage: ACTIVE - Used for external API calls when needed, though app primarily uses local database

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

/// API client for HTTP requests
class ApiClient {
  late final Dio _dio;

  // Singleton pattern
  static final ApiClient instance = ApiClient._internal();

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),);

    // Add interceptors
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (kDebugMode) {
            debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
            debugPrint('Headers: ${options.headers}');
            debugPrint('Data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',);
            debugPrint('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
                'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',);
            debugPrint('Message: ${error.message}');
            debugPrint('Response: ${error.response?.data}');
          }

          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Handle unauthorized - refresh token or logout
            _handleUnauthorized();
          }

          handler.next(error);
        },
      ),
    );
  }

  String? _getAuthToken() {
    // TODO: Get from secure storage
    return null;
  }

  void _handleUnauthorized() {
    // TODO: Handle token refresh or logout
  }

  /// Set auth token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle and transform errors
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiException('Connection timeout', statusCode: 0);

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          final message = error.response?.data['message'] ??
              error.response?.statusMessage ??
              'Unknown error';
          return ApiException(message, statusCode: statusCode);

        case DioExceptionType.cancel:
          return ApiException('Request cancelled', statusCode: 0);

        default:
          return ApiException('Network error', statusCode: 0);
      }
    }
    return Exception('Unknown error: $error');
  }
}

/// Custom API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException(this.message, {required this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
