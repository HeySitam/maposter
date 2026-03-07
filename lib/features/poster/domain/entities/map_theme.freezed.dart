// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapTheme {

 String get id; String get name; String get description;@ColorConverter() Color get bg;@ColorConverter() Color get text;@JsonKey(name: 'gradient_color')@ColorConverter() Color get gradientColor;@ColorConverter() Color get water;@ColorConverter() Color get parks;@JsonKey(name: 'road_motorway')@ColorConverter() Color get roadMotorway;@JsonKey(name: 'road_primary')@ColorConverter() Color get roadPrimary;@JsonKey(name: 'road_secondary')@ColorConverter() Color get roadSecondary;@JsonKey(name: 'road_tertiary')@ColorConverter() Color get roadTertiary;@JsonKey(name: 'road_residential')@ColorConverter() Color get roadResidential;@JsonKey(name: 'road_default')@ColorConverter() Color get roadDefault;
/// Create a copy of MapTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapThemeCopyWith<MapTheme> get copyWith => _$MapThemeCopyWithImpl<MapTheme>(this as MapTheme, _$identity);

  /// Serializes this MapTheme to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.bg, bg) || other.bg == bg)&&(identical(other.text, text) || other.text == text)&&(identical(other.gradientColor, gradientColor) || other.gradientColor == gradientColor)&&(identical(other.water, water) || other.water == water)&&(identical(other.parks, parks) || other.parks == parks)&&(identical(other.roadMotorway, roadMotorway) || other.roadMotorway == roadMotorway)&&(identical(other.roadPrimary, roadPrimary) || other.roadPrimary == roadPrimary)&&(identical(other.roadSecondary, roadSecondary) || other.roadSecondary == roadSecondary)&&(identical(other.roadTertiary, roadTertiary) || other.roadTertiary == roadTertiary)&&(identical(other.roadResidential, roadResidential) || other.roadResidential == roadResidential)&&(identical(other.roadDefault, roadDefault) || other.roadDefault == roadDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,bg,text,gradientColor,water,parks,roadMotorway,roadPrimary,roadSecondary,roadTertiary,roadResidential,roadDefault);

@override
String toString() {
  return 'MapTheme(id: $id, name: $name, description: $description, bg: $bg, text: $text, gradientColor: $gradientColor, water: $water, parks: $parks, roadMotorway: $roadMotorway, roadPrimary: $roadPrimary, roadSecondary: $roadSecondary, roadTertiary: $roadTertiary, roadResidential: $roadResidential, roadDefault: $roadDefault)';
}


}

/// @nodoc
abstract mixin class $MapThemeCopyWith<$Res>  {
  factory $MapThemeCopyWith(MapTheme value, $Res Function(MapTheme) _then) = _$MapThemeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description,@ColorConverter() Color bg,@ColorConverter() Color text,@JsonKey(name: 'gradient_color')@ColorConverter() Color gradientColor,@ColorConverter() Color water,@ColorConverter() Color parks,@JsonKey(name: 'road_motorway')@ColorConverter() Color roadMotorway,@JsonKey(name: 'road_primary')@ColorConverter() Color roadPrimary,@JsonKey(name: 'road_secondary')@ColorConverter() Color roadSecondary,@JsonKey(name: 'road_tertiary')@ColorConverter() Color roadTertiary,@JsonKey(name: 'road_residential')@ColorConverter() Color roadResidential,@JsonKey(name: 'road_default')@ColorConverter() Color roadDefault
});




}
/// @nodoc
class _$MapThemeCopyWithImpl<$Res>
    implements $MapThemeCopyWith<$Res> {
  _$MapThemeCopyWithImpl(this._self, this._then);

  final MapTheme _self;
  final $Res Function(MapTheme) _then;

/// Create a copy of MapTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? bg = null,Object? text = null,Object? gradientColor = null,Object? water = null,Object? parks = null,Object? roadMotorway = null,Object? roadPrimary = null,Object? roadSecondary = null,Object? roadTertiary = null,Object? roadResidential = null,Object? roadDefault = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,bg: null == bg ? _self.bg : bg // ignore: cast_nullable_to_non_nullable
as Color,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Color,gradientColor: null == gradientColor ? _self.gradientColor : gradientColor // ignore: cast_nullable_to_non_nullable
as Color,water: null == water ? _self.water : water // ignore: cast_nullable_to_non_nullable
as Color,parks: null == parks ? _self.parks : parks // ignore: cast_nullable_to_non_nullable
as Color,roadMotorway: null == roadMotorway ? _self.roadMotorway : roadMotorway // ignore: cast_nullable_to_non_nullable
as Color,roadPrimary: null == roadPrimary ? _self.roadPrimary : roadPrimary // ignore: cast_nullable_to_non_nullable
as Color,roadSecondary: null == roadSecondary ? _self.roadSecondary : roadSecondary // ignore: cast_nullable_to_non_nullable
as Color,roadTertiary: null == roadTertiary ? _self.roadTertiary : roadTertiary // ignore: cast_nullable_to_non_nullable
as Color,roadResidential: null == roadResidential ? _self.roadResidential : roadResidential // ignore: cast_nullable_to_non_nullable
as Color,roadDefault: null == roadDefault ? _self.roadDefault : roadDefault // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}


/// Adds pattern-matching-related methods to [MapTheme].
extension MapThemePatterns on MapTheme {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapTheme value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapTheme() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapTheme value)  $default,){
final _that = this;
switch (_that) {
case _MapTheme():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapTheme value)?  $default,){
final _that = this;
switch (_that) {
case _MapTheme() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description, @ColorConverter()  Color bg, @ColorConverter()  Color text, @JsonKey(name: 'gradient_color')@ColorConverter()  Color gradientColor, @ColorConverter()  Color water, @ColorConverter()  Color parks, @JsonKey(name: 'road_motorway')@ColorConverter()  Color roadMotorway, @JsonKey(name: 'road_primary')@ColorConverter()  Color roadPrimary, @JsonKey(name: 'road_secondary')@ColorConverter()  Color roadSecondary, @JsonKey(name: 'road_tertiary')@ColorConverter()  Color roadTertiary, @JsonKey(name: 'road_residential')@ColorConverter()  Color roadResidential, @JsonKey(name: 'road_default')@ColorConverter()  Color roadDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapTheme() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.bg,_that.text,_that.gradientColor,_that.water,_that.parks,_that.roadMotorway,_that.roadPrimary,_that.roadSecondary,_that.roadTertiary,_that.roadResidential,_that.roadDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description, @ColorConverter()  Color bg, @ColorConverter()  Color text, @JsonKey(name: 'gradient_color')@ColorConverter()  Color gradientColor, @ColorConverter()  Color water, @ColorConverter()  Color parks, @JsonKey(name: 'road_motorway')@ColorConverter()  Color roadMotorway, @JsonKey(name: 'road_primary')@ColorConverter()  Color roadPrimary, @JsonKey(name: 'road_secondary')@ColorConverter()  Color roadSecondary, @JsonKey(name: 'road_tertiary')@ColorConverter()  Color roadTertiary, @JsonKey(name: 'road_residential')@ColorConverter()  Color roadResidential, @JsonKey(name: 'road_default')@ColorConverter()  Color roadDefault)  $default,) {final _that = this;
switch (_that) {
case _MapTheme():
return $default(_that.id,_that.name,_that.description,_that.bg,_that.text,_that.gradientColor,_that.water,_that.parks,_that.roadMotorway,_that.roadPrimary,_that.roadSecondary,_that.roadTertiary,_that.roadResidential,_that.roadDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description, @ColorConverter()  Color bg, @ColorConverter()  Color text, @JsonKey(name: 'gradient_color')@ColorConverter()  Color gradientColor, @ColorConverter()  Color water, @ColorConverter()  Color parks, @JsonKey(name: 'road_motorway')@ColorConverter()  Color roadMotorway, @JsonKey(name: 'road_primary')@ColorConverter()  Color roadPrimary, @JsonKey(name: 'road_secondary')@ColorConverter()  Color roadSecondary, @JsonKey(name: 'road_tertiary')@ColorConverter()  Color roadTertiary, @JsonKey(name: 'road_residential')@ColorConverter()  Color roadResidential, @JsonKey(name: 'road_default')@ColorConverter()  Color roadDefault)?  $default,) {final _that = this;
switch (_that) {
case _MapTheme() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.bg,_that.text,_that.gradientColor,_that.water,_that.parks,_that.roadMotorway,_that.roadPrimary,_that.roadSecondary,_that.roadTertiary,_that.roadResidential,_that.roadDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapTheme extends MapTheme {
  const _MapTheme({required this.id, required this.name, required this.description, @ColorConverter() required this.bg, @ColorConverter() required this.text, @JsonKey(name: 'gradient_color')@ColorConverter() required this.gradientColor, @ColorConverter() required this.water, @ColorConverter() required this.parks, @JsonKey(name: 'road_motorway')@ColorConverter() required this.roadMotorway, @JsonKey(name: 'road_primary')@ColorConverter() required this.roadPrimary, @JsonKey(name: 'road_secondary')@ColorConverter() required this.roadSecondary, @JsonKey(name: 'road_tertiary')@ColorConverter() required this.roadTertiary, @JsonKey(name: 'road_residential')@ColorConverter() required this.roadResidential, @JsonKey(name: 'road_default')@ColorConverter() required this.roadDefault}): super._();
  factory _MapTheme.fromJson(Map<String, dynamic> json) => _$MapThemeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override@ColorConverter() final  Color bg;
@override@ColorConverter() final  Color text;
@override@JsonKey(name: 'gradient_color')@ColorConverter() final  Color gradientColor;
@override@ColorConverter() final  Color water;
@override@ColorConverter() final  Color parks;
@override@JsonKey(name: 'road_motorway')@ColorConverter() final  Color roadMotorway;
@override@JsonKey(name: 'road_primary')@ColorConverter() final  Color roadPrimary;
@override@JsonKey(name: 'road_secondary')@ColorConverter() final  Color roadSecondary;
@override@JsonKey(name: 'road_tertiary')@ColorConverter() final  Color roadTertiary;
@override@JsonKey(name: 'road_residential')@ColorConverter() final  Color roadResidential;
@override@JsonKey(name: 'road_default')@ColorConverter() final  Color roadDefault;

/// Create a copy of MapTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapThemeCopyWith<_MapTheme> get copyWith => __$MapThemeCopyWithImpl<_MapTheme>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapThemeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapTheme&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.bg, bg) || other.bg == bg)&&(identical(other.text, text) || other.text == text)&&(identical(other.gradientColor, gradientColor) || other.gradientColor == gradientColor)&&(identical(other.water, water) || other.water == water)&&(identical(other.parks, parks) || other.parks == parks)&&(identical(other.roadMotorway, roadMotorway) || other.roadMotorway == roadMotorway)&&(identical(other.roadPrimary, roadPrimary) || other.roadPrimary == roadPrimary)&&(identical(other.roadSecondary, roadSecondary) || other.roadSecondary == roadSecondary)&&(identical(other.roadTertiary, roadTertiary) || other.roadTertiary == roadTertiary)&&(identical(other.roadResidential, roadResidential) || other.roadResidential == roadResidential)&&(identical(other.roadDefault, roadDefault) || other.roadDefault == roadDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,bg,text,gradientColor,water,parks,roadMotorway,roadPrimary,roadSecondary,roadTertiary,roadResidential,roadDefault);

@override
String toString() {
  return 'MapTheme(id: $id, name: $name, description: $description, bg: $bg, text: $text, gradientColor: $gradientColor, water: $water, parks: $parks, roadMotorway: $roadMotorway, roadPrimary: $roadPrimary, roadSecondary: $roadSecondary, roadTertiary: $roadTertiary, roadResidential: $roadResidential, roadDefault: $roadDefault)';
}


}

/// @nodoc
abstract mixin class _$MapThemeCopyWith<$Res> implements $MapThemeCopyWith<$Res> {
  factory _$MapThemeCopyWith(_MapTheme value, $Res Function(_MapTheme) _then) = __$MapThemeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description,@ColorConverter() Color bg,@ColorConverter() Color text,@JsonKey(name: 'gradient_color')@ColorConverter() Color gradientColor,@ColorConverter() Color water,@ColorConverter() Color parks,@JsonKey(name: 'road_motorway')@ColorConverter() Color roadMotorway,@JsonKey(name: 'road_primary')@ColorConverter() Color roadPrimary,@JsonKey(name: 'road_secondary')@ColorConverter() Color roadSecondary,@JsonKey(name: 'road_tertiary')@ColorConverter() Color roadTertiary,@JsonKey(name: 'road_residential')@ColorConverter() Color roadResidential,@JsonKey(name: 'road_default')@ColorConverter() Color roadDefault
});




}
/// @nodoc
class __$MapThemeCopyWithImpl<$Res>
    implements _$MapThemeCopyWith<$Res> {
  __$MapThemeCopyWithImpl(this._self, this._then);

  final _MapTheme _self;
  final $Res Function(_MapTheme) _then;

/// Create a copy of MapTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? bg = null,Object? text = null,Object? gradientColor = null,Object? water = null,Object? parks = null,Object? roadMotorway = null,Object? roadPrimary = null,Object? roadSecondary = null,Object? roadTertiary = null,Object? roadResidential = null,Object? roadDefault = null,}) {
  return _then(_MapTheme(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,bg: null == bg ? _self.bg : bg // ignore: cast_nullable_to_non_nullable
as Color,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Color,gradientColor: null == gradientColor ? _self.gradientColor : gradientColor // ignore: cast_nullable_to_non_nullable
as Color,water: null == water ? _self.water : water // ignore: cast_nullable_to_non_nullable
as Color,parks: null == parks ? _self.parks : parks // ignore: cast_nullable_to_non_nullable
as Color,roadMotorway: null == roadMotorway ? _self.roadMotorway : roadMotorway // ignore: cast_nullable_to_non_nullable
as Color,roadPrimary: null == roadPrimary ? _self.roadPrimary : roadPrimary // ignore: cast_nullable_to_non_nullable
as Color,roadSecondary: null == roadSecondary ? _self.roadSecondary : roadSecondary // ignore: cast_nullable_to_non_nullable
as Color,roadTertiary: null == roadTertiary ? _self.roadTertiary : roadTertiary // ignore: cast_nullable_to_non_nullable
as Color,roadResidential: null == roadResidential ? _self.roadResidential : roadResidential // ignore: cast_nullable_to_non_nullable
as Color,roadDefault: null == roadDefault ? _self.roadDefault : roadDefault // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}

// dart format on
