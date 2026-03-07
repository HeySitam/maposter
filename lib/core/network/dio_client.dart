import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:map_to_poster/core/constants/app_constants.dart';
import 'package:map_to_poster/core/errors/app_exception.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final _logger = PrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
);

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
    )..interceptors.addAll([if (kDebugMode) _logger, _AppInterceptor()]);

Dio buildOverpassDio() => Dio(
      BaseOptions(
        baseUrl: AppConstants.overpassBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.networkTimeoutSeconds),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.addAll([if (kDebugMode) _logger, _AppInterceptor()]);

class _AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final msg = err.message ?? err.type.name;
    final status = err.response?.statusCode;
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
