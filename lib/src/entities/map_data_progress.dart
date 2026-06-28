/// The map-data fetch stage a [MapDataProgress] event refers to.
///
/// `fetchMapData` runs these three Overpass queries in order; geocoding happens
/// before `fetchMapData` is called, so it is not reported here.
enum MapDataStage { roads, water, parks }

/// Progress emitted by `MaposterEngine.fetchMapData` (and the underlying
/// repository) as it starts each [MapDataStage]. Use it to drive a staged
/// progress UI — the first-time fetch of a city involves several slow,
/// rate-limited network calls.
class MapDataProgress {
  const MapDataProgress({
    required this.stage,
    required this.index,
    required this.total,
    required this.fromCache,
  });

  /// The stage that is now starting.
  final MapDataStage stage;

  /// Zero-based position of [stage] among the stages (0 = roads … 2 = parks).
  final int index;

  /// Total number of stages (always 3).
  final int total;

  /// Whether this stage is served from cache (i.e. resolves instantly with no
  /// network request).
  final bool fromCache;

  @override
  String toString() =>
      'MapDataProgress(${stage.name}, ${index + 1}/$total, fromCache: $fromCache)';
}

/// Callback invoked as each map-data stage begins.
typedef MapDataProgressCallback = void Function(MapDataProgress progress);
