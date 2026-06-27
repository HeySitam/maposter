// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoadSegment {

 List<LatLon> get coordinates; RoadType get type;
/// Create a copy of RoadSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoadSegmentCopyWith<RoadSegment> get copyWith => _$RoadSegmentCopyWithImpl<RoadSegment>(this as RoadSegment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoadSegment&&const DeepCollectionEquality().equals(other.coordinates, coordinates)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(coordinates),type);

@override
String toString() {
  return 'RoadSegment(coordinates: $coordinates, type: $type)';
}


}

/// @nodoc
abstract mixin class $RoadSegmentCopyWith<$Res>  {
  factory $RoadSegmentCopyWith(RoadSegment value, $Res Function(RoadSegment) _then) = _$RoadSegmentCopyWithImpl;
@useResult
$Res call({
 List<LatLon> coordinates, RoadType type
});




}
/// @nodoc
class _$RoadSegmentCopyWithImpl<$Res>
    implements $RoadSegmentCopyWith<$Res> {
  _$RoadSegmentCopyWithImpl(this._self, this._then);

  final RoadSegment _self;
  final $Res Function(RoadSegment) _then;

/// Create a copy of RoadSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? coordinates = null,Object? type = null,}) {
  return _then(_self.copyWith(
coordinates: null == coordinates ? _self.coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<LatLon>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoadType,
  ));
}

}


/// Adds pattern-matching-related methods to [RoadSegment].
extension RoadSegmentPatterns on RoadSegment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoadSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoadSegment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoadSegment value)  $default,){
final _that = this;
switch (_that) {
case _RoadSegment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoadSegment value)?  $default,){
final _that = this;
switch (_that) {
case _RoadSegment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LatLon> coordinates,  RoadType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoadSegment() when $default != null:
return $default(_that.coordinates,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LatLon> coordinates,  RoadType type)  $default,) {final _that = this;
switch (_that) {
case _RoadSegment():
return $default(_that.coordinates,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LatLon> coordinates,  RoadType type)?  $default,) {final _that = this;
switch (_that) {
case _RoadSegment() when $default != null:
return $default(_that.coordinates,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _RoadSegment implements RoadSegment {
  const _RoadSegment({required final  List<LatLon> coordinates, required this.type}): _coordinates = coordinates;
  

 final  List<LatLon> _coordinates;
@override List<LatLon> get coordinates {
  if (_coordinates is EqualUnmodifiableListView) return _coordinates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coordinates);
}

@override final  RoadType type;

/// Create a copy of RoadSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoadSegmentCopyWith<_RoadSegment> get copyWith => __$RoadSegmentCopyWithImpl<_RoadSegment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoadSegment&&const DeepCollectionEquality().equals(other._coordinates, _coordinates)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_coordinates),type);

@override
String toString() {
  return 'RoadSegment(coordinates: $coordinates, type: $type)';
}


}

/// @nodoc
abstract mixin class _$RoadSegmentCopyWith<$Res> implements $RoadSegmentCopyWith<$Res> {
  factory _$RoadSegmentCopyWith(_RoadSegment value, $Res Function(_RoadSegment) _then) = __$RoadSegmentCopyWithImpl;
@override @useResult
$Res call({
 List<LatLon> coordinates, RoadType type
});




}
/// @nodoc
class __$RoadSegmentCopyWithImpl<$Res>
    implements _$RoadSegmentCopyWith<$Res> {
  __$RoadSegmentCopyWithImpl(this._self, this._then);

  final _RoadSegment _self;
  final $Res Function(_RoadSegment) _then;

/// Create a copy of RoadSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? coordinates = null,Object? type = null,}) {
  return _then(_RoadSegment(
coordinates: null == coordinates ? _self._coordinates : coordinates // ignore: cast_nullable_to_non_nullable
as List<LatLon>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoadType,
  ));
}


}

/// @nodoc
mixin _$MapFeature {

 List<List<LatLon>> get rings; FeatureType get type;
/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapFeatureCopyWith<MapFeature> get copyWith => _$MapFeatureCopyWithImpl<MapFeature>(this as MapFeature, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapFeature&&const DeepCollectionEquality().equals(other.rings, rings)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rings),type);

@override
String toString() {
  return 'MapFeature(rings: $rings, type: $type)';
}


}

/// @nodoc
abstract mixin class $MapFeatureCopyWith<$Res>  {
  factory $MapFeatureCopyWith(MapFeature value, $Res Function(MapFeature) _then) = _$MapFeatureCopyWithImpl;
@useResult
$Res call({
 List<List<LatLon>> rings, FeatureType type
});




}
/// @nodoc
class _$MapFeatureCopyWithImpl<$Res>
    implements $MapFeatureCopyWith<$Res> {
  _$MapFeatureCopyWithImpl(this._self, this._then);

  final MapFeature _self;
  final $Res Function(MapFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rings = null,Object? type = null,}) {
  return _then(_self.copyWith(
rings: null == rings ? _self.rings : rings // ignore: cast_nullable_to_non_nullable
as List<List<LatLon>>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeatureType,
  ));
}

}


/// Adds pattern-matching-related methods to [MapFeature].
extension MapFeaturePatterns on MapFeature {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapFeature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapFeature value)  $default,){
final _that = this;
switch (_that) {
case _MapFeature():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapFeature value)?  $default,){
final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<List<LatLon>> rings,  FeatureType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that.rings,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<List<LatLon>> rings,  FeatureType type)  $default,) {final _that = this;
switch (_that) {
case _MapFeature():
return $default(_that.rings,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<List<LatLon>> rings,  FeatureType type)?  $default,) {final _that = this;
switch (_that) {
case _MapFeature() when $default != null:
return $default(_that.rings,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _MapFeature implements MapFeature {
  const _MapFeature({required final  List<List<LatLon>> rings, required this.type}): _rings = rings;
  

 final  List<List<LatLon>> _rings;
@override List<List<LatLon>> get rings {
  if (_rings is EqualUnmodifiableListView) return _rings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rings);
}

@override final  FeatureType type;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapFeatureCopyWith<_MapFeature> get copyWith => __$MapFeatureCopyWithImpl<_MapFeature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapFeature&&const DeepCollectionEquality().equals(other._rings, _rings)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rings),type);

@override
String toString() {
  return 'MapFeature(rings: $rings, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MapFeatureCopyWith<$Res> implements $MapFeatureCopyWith<$Res> {
  factory _$MapFeatureCopyWith(_MapFeature value, $Res Function(_MapFeature) _then) = __$MapFeatureCopyWithImpl;
@override @useResult
$Res call({
 List<List<LatLon>> rings, FeatureType type
});




}
/// @nodoc
class __$MapFeatureCopyWithImpl<$Res>
    implements _$MapFeatureCopyWith<$Res> {
  __$MapFeatureCopyWithImpl(this._self, this._then);

  final _MapFeature _self;
  final $Res Function(_MapFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rings = null,Object? type = null,}) {
  return _then(_MapFeature(
rings: null == rings ? _self._rings : rings // ignore: cast_nullable_to_non_nullable
as List<List<LatLon>>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FeatureType,
  ));
}


}

/// @nodoc
mixin _$MapData {

 List<RoadSegment> get roads; List<MapFeature> get waterFeatures; List<MapFeature> get parkFeatures; LatLonBounds get bounds;
/// Create a copy of MapData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapDataCopyWith<MapData> get copyWith => _$MapDataCopyWithImpl<MapData>(this as MapData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapData&&const DeepCollectionEquality().equals(other.roads, roads)&&const DeepCollectionEquality().equals(other.waterFeatures, waterFeatures)&&const DeepCollectionEquality().equals(other.parkFeatures, parkFeatures)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(roads),const DeepCollectionEquality().hash(waterFeatures),const DeepCollectionEquality().hash(parkFeatures),bounds);

@override
String toString() {
  return 'MapData(roads: $roads, waterFeatures: $waterFeatures, parkFeatures: $parkFeatures, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class $MapDataCopyWith<$Res>  {
  factory $MapDataCopyWith(MapData value, $Res Function(MapData) _then) = _$MapDataCopyWithImpl;
@useResult
$Res call({
 List<RoadSegment> roads, List<MapFeature> waterFeatures, List<MapFeature> parkFeatures, LatLonBounds bounds
});




}
/// @nodoc
class _$MapDataCopyWithImpl<$Res>
    implements $MapDataCopyWith<$Res> {
  _$MapDataCopyWithImpl(this._self, this._then);

  final MapData _self;
  final $Res Function(MapData) _then;

/// Create a copy of MapData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roads = null,Object? waterFeatures = null,Object? parkFeatures = null,Object? bounds = null,}) {
  return _then(_self.copyWith(
roads: null == roads ? _self.roads : roads // ignore: cast_nullable_to_non_nullable
as List<RoadSegment>,waterFeatures: null == waterFeatures ? _self.waterFeatures : waterFeatures // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,parkFeatures: null == parkFeatures ? _self.parkFeatures : parkFeatures // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as LatLonBounds,
  ));
}

}


/// Adds pattern-matching-related methods to [MapData].
extension MapDataPatterns on MapData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapData value)  $default,){
final _that = this;
switch (_that) {
case _MapData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapData value)?  $default,){
final _that = this;
switch (_that) {
case _MapData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RoadSegment> roads,  List<MapFeature> waterFeatures,  List<MapFeature> parkFeatures,  LatLonBounds bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapData() when $default != null:
return $default(_that.roads,_that.waterFeatures,_that.parkFeatures,_that.bounds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RoadSegment> roads,  List<MapFeature> waterFeatures,  List<MapFeature> parkFeatures,  LatLonBounds bounds)  $default,) {final _that = this;
switch (_that) {
case _MapData():
return $default(_that.roads,_that.waterFeatures,_that.parkFeatures,_that.bounds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RoadSegment> roads,  List<MapFeature> waterFeatures,  List<MapFeature> parkFeatures,  LatLonBounds bounds)?  $default,) {final _that = this;
switch (_that) {
case _MapData() when $default != null:
return $default(_that.roads,_that.waterFeatures,_that.parkFeatures,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc


class _MapData extends MapData {
  const _MapData({required final  List<RoadSegment> roads, required final  List<MapFeature> waterFeatures, required final  List<MapFeature> parkFeatures, required this.bounds}): _roads = roads,_waterFeatures = waterFeatures,_parkFeatures = parkFeatures,super._();
  

 final  List<RoadSegment> _roads;
@override List<RoadSegment> get roads {
  if (_roads is EqualUnmodifiableListView) return _roads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roads);
}

 final  List<MapFeature> _waterFeatures;
@override List<MapFeature> get waterFeatures {
  if (_waterFeatures is EqualUnmodifiableListView) return _waterFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_waterFeatures);
}

 final  List<MapFeature> _parkFeatures;
@override List<MapFeature> get parkFeatures {
  if (_parkFeatures is EqualUnmodifiableListView) return _parkFeatures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parkFeatures);
}

@override final  LatLonBounds bounds;

/// Create a copy of MapData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapDataCopyWith<_MapData> get copyWith => __$MapDataCopyWithImpl<_MapData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapData&&const DeepCollectionEquality().equals(other._roads, _roads)&&const DeepCollectionEquality().equals(other._waterFeatures, _waterFeatures)&&const DeepCollectionEquality().equals(other._parkFeatures, _parkFeatures)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_roads),const DeepCollectionEquality().hash(_waterFeatures),const DeepCollectionEquality().hash(_parkFeatures),bounds);

@override
String toString() {
  return 'MapData(roads: $roads, waterFeatures: $waterFeatures, parkFeatures: $parkFeatures, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$MapDataCopyWith<$Res> implements $MapDataCopyWith<$Res> {
  factory _$MapDataCopyWith(_MapData value, $Res Function(_MapData) _then) = __$MapDataCopyWithImpl;
@override @useResult
$Res call({
 List<RoadSegment> roads, List<MapFeature> waterFeatures, List<MapFeature> parkFeatures, LatLonBounds bounds
});




}
/// @nodoc
class __$MapDataCopyWithImpl<$Res>
    implements _$MapDataCopyWith<$Res> {
  __$MapDataCopyWithImpl(this._self, this._then);

  final _MapData _self;
  final $Res Function(_MapData) _then;

/// Create a copy of MapData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roads = null,Object? waterFeatures = null,Object? parkFeatures = null,Object? bounds = null,}) {
  return _then(_MapData(
roads: null == roads ? _self._roads : roads // ignore: cast_nullable_to_non_nullable
as List<RoadSegment>,waterFeatures: null == waterFeatures ? _self._waterFeatures : waterFeatures // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,parkFeatures: null == parkFeatures ? _self._parkFeatures : parkFeatures // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as LatLonBounds,
  ));
}


}

// dart format on
