/// Configuration for [MaposterEngine].
///
/// [userAgent] is **required**: the OpenStreetMap Nominatim usage policy
/// requires a real, identifying User-Agent (an app name + contact). Generic or
/// empty agents may be blocked. Example: `'myapp/1.0 (com.example.myapp)'`.
class MaposterConfig {
  const MaposterConfig({
    required this.userAgent,
    this.defaultRadiusMeters = 18000,
    this.nominatimBaseUrl = 'https://nominatim.openstreetmap.org',
    this.overpassBaseUrl = 'https://overpass-api.de/api/interpreter',
    this.nominatimMinGap = const Duration(milliseconds: 1100),
    this.overpassMinGap = const Duration(seconds: 2),
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.overpassReceiveTimeout = const Duration(seconds: 60),
  });

  /// Identifying User-Agent sent to Nominatim (required by its usage policy).
  final String userAgent;

  /// Default map fetch radius in metres, used when none is passed to
  /// `fetchMapData`.
  final double defaultRadiusMeters;

  final String nominatimBaseUrl;
  final String overpassBaseUrl;

  /// Minimum gap between Nominatim requests (its policy is ~1 req/sec).
  final Duration nominatimMinGap;

  /// Minimum gap between Overpass requests.
  final Duration overpassMinGap;

  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Receive timeout for Overpass (larger; queries can be slow).
  final Duration overpassReceiveTimeout;
}
