/// Base type for all errors thrown by the engine. `switch` over the sealed
/// subtypes to handle specific failures, or read [message] for a user-facing
/// string.
sealed class AppException implements Exception {
  const AppException(this.message);

  /// Human-readable description of the failure.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// A network/HTTP failure. [statusCode] is the response status when available.
final class NetworkException extends AppException {
  const NetworkException(super.message, {this.statusCode});
  final int? statusCode;
}

/// Geocoding (Nominatim) failed or returned no match.
final class GeocodingException extends AppException {
  const GeocodingException(super.message);
}

/// An Overpass map-data request failed.
final class OverpassException extends AppException {
  const OverpassException(super.message);
}

/// Reading from or writing to the cache store failed.
final class CacheException extends AppException {
  const CacheException(super.message);
}

/// Rendering or encoding the poster image failed.
final class RenderException extends AppException {
  const RenderException(super.message);
}

/// A bundled asset (e.g. a theme JSON) could not be loaded or was invalid.
final class AssetException extends AppException {
  const AssetException(super.message);
}
