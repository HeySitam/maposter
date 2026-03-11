import 'package:dio/dio.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';

Dio buildNominatimDio() => Dio(
      BaseOptions(
        baseUrl: AppConstants.nominatimBaseUrl,
        headers: {
          'User-Agent': AppConstants.userAgent,
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: AppConstants.networkTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.networkTimeoutSeconds),
      ),
    )..interceptors.add(_AppInterceptor());

Dio buildOverpassDio() => Dio(
      BaseOptions(
        baseUrl: AppConstants.overpassBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.networkTimeoutSeconds),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.add(_AppInterceptor());

class _AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Don't wrap cancellations — preserve DioExceptionType.cancel for callers
    if (err.type == DioExceptionType.cancel) {
      handler.next(err);
      return;
    }
    final status = err.response?.statusCode;
    final msg = switch (status) {
      429 => 'Too many requests — please wait and try again.',
      502 => 'Server temporarily unavailable — please try again.',
      504 => 'Request timed out — please try again.',
      null => 'Network error (${err.type.name}).',
      _ => 'Server error ($status) — please try again.',
    };
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: NetworkException(msg, statusCode: status),
        type: err.type,
        response: err.response,
      ),
    );
  }
}
