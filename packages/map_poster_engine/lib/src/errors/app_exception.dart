sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {this.statusCode});
  final int? statusCode;
}

final class GeocodingException extends AppException {
  const GeocodingException(super.message);
}

final class OverpassException extends AppException {
  const OverpassException(super.message);
}

final class CacheException extends AppException {
  const CacheException(super.message);
}

final class RenderException extends AppException {
  const RenderException(super.message);
}

final class AssetException extends AppException {
  const AssetException(super.message);
}
