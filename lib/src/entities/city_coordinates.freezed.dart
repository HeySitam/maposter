// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'city_coordinates.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CityCoordinates {

 double get latitude; double get longitude; String get displayName; String? get city; String? get country;
/// Create a copy of CityCoordinates
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CityCoordinatesCopyWith<CityCoordinates> get copyWith => _$CityCoordinatesCopyWithImpl<CityCoordinates>(this as CityCoordinates, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CityCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,displayName,city,country);

@override
String toString() {
  return 'CityCoordinates(latitude: $latitude, longitude: $longitude, displayName: $displayName, city: $city, country: $country)';
}


}

/// @nodoc
abstract mixin class $CityCoordinatesCopyWith<$Res>  {
  factory $CityCoordinatesCopyWith(CityCoordinates value, $Res Function(CityCoordinates) _then) = _$CityCoordinatesCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, String displayName, String? city, String? country
});




}
/// @nodoc
class _$CityCoordinatesCopyWithImpl<$Res>
    implements $CityCoordinatesCopyWith<$Res> {
  _$CityCoordinatesCopyWithImpl(this._self, this._then);

  final CityCoordinates _self;
  final $Res Function(CityCoordinates) _then;

/// Create a copy of CityCoordinates
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? displayName = null,Object? city = freezed,Object? country = freezed,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CityCoordinates].
extension CityCoordinatesPatterns on CityCoordinates {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CityCoordinates value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CityCoordinates() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CityCoordinates value)  $default,){
final _that = this;
switch (_that) {
case _CityCoordinates():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CityCoordinates value)?  $default,){
final _that = this;
switch (_that) {
case _CityCoordinates() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String displayName,  String? city,  String? country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CityCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude,_that.displayName,_that.city,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  String displayName,  String? city,  String? country)  $default,) {final _that = this;
switch (_that) {
case _CityCoordinates():
return $default(_that.latitude,_that.longitude,_that.displayName,_that.city,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  String displayName,  String? city,  String? country)?  $default,) {final _that = this;
switch (_that) {
case _CityCoordinates() when $default != null:
return $default(_that.latitude,_that.longitude,_that.displayName,_that.city,_that.country);case _:
  return null;

}
}

}

/// @nodoc


class _CityCoordinates implements CityCoordinates {
  const _CityCoordinates({required this.latitude, required this.longitude, required this.displayName, this.city, this.country});
  

@override final  double latitude;
@override final  double longitude;
@override final  String displayName;
@override final  String? city;
@override final  String? country;

/// Create a copy of CityCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CityCoordinatesCopyWith<_CityCoordinates> get copyWith => __$CityCoordinatesCopyWithImpl<_CityCoordinates>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CityCoordinates&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,displayName,city,country);

@override
String toString() {
  return 'CityCoordinates(latitude: $latitude, longitude: $longitude, displayName: $displayName, city: $city, country: $country)';
}


}

/// @nodoc
abstract mixin class _$CityCoordinatesCopyWith<$Res> implements $CityCoordinatesCopyWith<$Res> {
  factory _$CityCoordinatesCopyWith(_CityCoordinates value, $Res Function(_CityCoordinates) _then) = __$CityCoordinatesCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, String displayName, String? city, String? country
});




}
/// @nodoc
class __$CityCoordinatesCopyWithImpl<$Res>
    implements _$CityCoordinatesCopyWith<$Res> {
  __$CityCoordinatesCopyWithImpl(this._self, this._then);

  final _CityCoordinates _self;
  final $Res Function(_CityCoordinates) _then;

/// Create a copy of CityCoordinates
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? displayName = null,Object? city = freezed,Object? country = freezed,}) {
  return _then(_CityCoordinates(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
