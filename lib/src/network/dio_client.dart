import 'package:dio/dio.dart';
import 'package:maposter/src/config/maposter_config.dart';
import 'package:maposter/src/errors/app_exception.dart';

Dio buildNominatimDio(MaposterConfig config) => Dio(
  BaseOptions(
    baseUrl: config.nominatimBaseUrl,
    headers: {'User-Agent': config.userAgent, 'Accept': 'application/json'},
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
  ),
)..interceptors.add(_AppInterceptor());

Dio buildOverpassDio(MaposterConfig config) => Dio(
  BaseOptions(
    baseUrl: config.overpassBaseUrl,
    headers: {'User-Agent': config.userAgent},
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.overpassReceiveTimeout,
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
