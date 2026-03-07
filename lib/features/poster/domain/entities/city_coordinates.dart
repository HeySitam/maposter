import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_coordinates.freezed.dart';

@freezed
abstract class CityCoordinates with _$CityCoordinates {
  const factory CityCoordinates({
    required double latitude,
    required double longitude,
    required String displayName,
    String? city,
    String? country,
  }) = _CityCoordinates;
}
