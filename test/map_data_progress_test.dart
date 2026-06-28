import 'package:flutter_test/flutter_test.dart';
import 'package:maposter/maposter.dart';
import 'package:maposter/src/datasources/local/overpass_local_datasource.dart';
import 'package:maposter/src/datasources/remote/overpass_remote_datasource.dart';
import 'package:maposter/src/repositories/map_data_repository_impl.dart';

class _FakeRemote implements OverpassRemoteDatasource {
  @override
  Future<List<RoadSegment>> fetchRoads(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async => const [];

  @override
  Future<List<MapFeature>> fetchWaterFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async => const [];

  @override
  Future<List<MapFeature>> fetchParkFeatures(
    LatLon center,
    double radiusMeters, {
    CancelToken? token,
  }) async => const [];
}

class _FakeLocal implements OverpassLocalDatasource {
  _FakeLocal({required this.hit});
  final bool hit;

  @override
  Future<List<RoadSegment>?> getRoads(String key) async =>
      hit ? const [] : null;

  @override
  Future<void> putRoads(String key, List<RoadSegment> roads) async {}

  @override
  Future<List<MapFeature>?> getFeatures(String key) async =>
      hit ? const [] : null;

  @override
  Future<void> putFeatures(String key, List<MapFeature> features) async {}
}

void main() {
  const center = (22.5726, 88.3639);

  test('emits roads → water → parks in order on a cache miss', () async {
    final repo = MapDataRepositoryImpl(_FakeRemote(), _FakeLocal(hit: false));
    final events = <MapDataProgress>[];

    await repo.fetchMapData(center, 18000, onProgress: events.add);

    expect(events.map((e) => e.stage), [
      MapDataStage.roads,
      MapDataStage.water,
      MapDataStage.parks,
    ]);
    expect(events.map((e) => e.index), [0, 1, 2]);
    expect(events.every((e) => e.total == 3), isTrue);
    expect(events.every((e) => e.fromCache == false), isTrue);
  });

  test('flags fromCache when every stage is served from cache', () async {
    final repo = MapDataRepositoryImpl(_FakeRemote(), _FakeLocal(hit: true));
    final events = <MapDataProgress>[];

    await repo.fetchMapData(center, 18000, onProgress: events.add);

    expect(events.length, 3);
    expect(events.every((e) => e.fromCache), isTrue);
  });

  test('onProgress is optional', () async {
    final repo = MapDataRepositoryImpl(_FakeRemote(), _FakeLocal(hit: false));
    await expectLater(repo.fetchMapData(center, 18000), completes);
  });
}
