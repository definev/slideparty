// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'playboard_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PlayboardConfigTearOff {
  const _$PlayboardConfigTearOff();

  NonePlayboardConfig none() {
    return const NonePlayboardConfig();
  }

  BlindPlayboardConfig blind(ButtonColors color) {
    return BlindPlayboardConfig(
      color,
    );
  }

  NumberPlayboardConfig number(ButtonColors color) {
    return NumberPlayboardConfig(
      color,
    );
  }

  MultiplePlayboardConfig multiple(Map<String, PlayboardConfig> configs) {
    return MultiplePlayboardConfig(
      configs,
    );
  }
}

/// @nodoc
const $PlayboardConfig = _$PlayboardConfigTearOff();

/// @nodoc
mixin _$PlayboardConfig {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(Map<String, PlayboardConfig> configs) multiple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NonePlayboardConfig value) none,
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayboardConfigCopyWith<$Res> {
  factory $PlayboardConfigCopyWith(
          PlayboardConfig value, $Res Function(PlayboardConfig) then) =
      _$PlayboardConfigCopyWithImpl<$Res>;
}

/// @nodoc
class _$PlayboardConfigCopyWithImpl<$Res>
    implements $PlayboardConfigCopyWith<$Res> {
  _$PlayboardConfigCopyWithImpl(this._value, this._then);

  final PlayboardConfig _value;
  // ignore: unused_field
  final $Res Function(PlayboardConfig) _then;
}

/// @nodoc
abstract class $NonePlayboardConfigCopyWith<$Res> {
  factory $NonePlayboardConfigCopyWith(
          NonePlayboardConfig value, $Res Function(NonePlayboardConfig) then) =
      _$NonePlayboardConfigCopyWithImpl<$Res>;
}

/// @nodoc
class _$NonePlayboardConfigCopyWithImpl<$Res>
    extends _$PlayboardConfigCopyWithImpl<$Res>
    implements $NonePlayboardConfigCopyWith<$Res> {
  _$NonePlayboardConfigCopyWithImpl(
      NonePlayboardConfig _value, $Res Function(NonePlayboardConfig) _then)
      : super(_value, (v) => _then(v as NonePlayboardConfig));

  @override
  NonePlayboardConfig get _value => super._value as NonePlayboardConfig;
}

/// @nodoc

class _$NonePlayboardConfig implements NonePlayboardConfig {
  const _$NonePlayboardConfig();

  @override
  String toString() {
    return 'PlayboardConfig.none()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NonePlayboardConfig);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(Map<String, PlayboardConfig> configs) multiple,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NonePlayboardConfig value) none,
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class NonePlayboardConfig implements PlayboardConfig {
  const factory NonePlayboardConfig() = _$NonePlayboardConfig;
}

/// @nodoc
abstract class $BlindPlayboardConfigCopyWith<$Res> {
  factory $BlindPlayboardConfigCopyWith(BlindPlayboardConfig value,
          $Res Function(BlindPlayboardConfig) then) =
      _$BlindPlayboardConfigCopyWithImpl<$Res>;
  $Res call({ButtonColors color});
}

/// @nodoc
class _$BlindPlayboardConfigCopyWithImpl<$Res>
    extends _$PlayboardConfigCopyWithImpl<$Res>
    implements $BlindPlayboardConfigCopyWith<$Res> {
  _$BlindPlayboardConfigCopyWithImpl(
      BlindPlayboardConfig _value, $Res Function(BlindPlayboardConfig) _then)
      : super(_value, (v) => _then(v as BlindPlayboardConfig));

  @override
  BlindPlayboardConfig get _value => super._value as BlindPlayboardConfig;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(BlindPlayboardConfig(
      color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as ButtonColors,
    ));
  }
}

/// @nodoc

class _$BlindPlayboardConfig implements BlindPlayboardConfig {
  const _$BlindPlayboardConfig(this.color);

  @override
  final ButtonColors color;

  @override
  String toString() {
    return 'PlayboardConfig.blind(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindPlayboardConfig &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $BlindPlayboardConfigCopyWith<BlindPlayboardConfig> get copyWith =>
      _$BlindPlayboardConfigCopyWithImpl<BlindPlayboardConfig>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(Map<String, PlayboardConfig> configs) multiple,
  }) {
    return blind(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
  }) {
    return blind?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
    required TResult orElse(),
  }) {
    if (blind != null) {
      return blind(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NonePlayboardConfig value) none,
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
  }) {
    return blind(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
  }) {
    return blind?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    required TResult orElse(),
  }) {
    if (blind != null) {
      return blind(this);
    }
    return orElse();
  }
}

abstract class BlindPlayboardConfig implements PlayboardConfig {
  const factory BlindPlayboardConfig(ButtonColors color) =
      _$BlindPlayboardConfig;

  ButtonColors get color;
  @JsonKey(ignore: true)
  $BlindPlayboardConfigCopyWith<BlindPlayboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NumberPlayboardConfigCopyWith<$Res> {
  factory $NumberPlayboardConfigCopyWith(NumberPlayboardConfig value,
          $Res Function(NumberPlayboardConfig) then) =
      _$NumberPlayboardConfigCopyWithImpl<$Res>;
  $Res call({ButtonColors color});
}

/// @nodoc
class _$NumberPlayboardConfigCopyWithImpl<$Res>
    extends _$PlayboardConfigCopyWithImpl<$Res>
    implements $NumberPlayboardConfigCopyWith<$Res> {
  _$NumberPlayboardConfigCopyWithImpl(
      NumberPlayboardConfig _value, $Res Function(NumberPlayboardConfig) _then)
      : super(_value, (v) => _then(v as NumberPlayboardConfig));

  @override
  NumberPlayboardConfig get _value => super._value as NumberPlayboardConfig;

  @override
  $Res call({
    Object? color = freezed,
  }) {
    return _then(NumberPlayboardConfig(
      color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as ButtonColors,
    ));
  }
}

/// @nodoc

class _$NumberPlayboardConfig implements NumberPlayboardConfig {
  const _$NumberPlayboardConfig(this.color);

  @override
  final ButtonColors color;

  @override
  String toString() {
    return 'PlayboardConfig.number(color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NumberPlayboardConfig &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  $NumberPlayboardConfigCopyWith<NumberPlayboardConfig> get copyWith =>
      _$NumberPlayboardConfigCopyWithImpl<NumberPlayboardConfig>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(Map<String, PlayboardConfig> configs) multiple,
  }) {
    return number(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
  }) {
    return number?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(color);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NonePlayboardConfig value) none,
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
  }) {
    return number(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
  }) {
    return number?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(this);
    }
    return orElse();
  }
}

abstract class NumberPlayboardConfig implements PlayboardConfig {
  const factory NumberPlayboardConfig(ButtonColors color) =
      _$NumberPlayboardConfig;

  ButtonColors get color;
  @JsonKey(ignore: true)
  $NumberPlayboardConfigCopyWith<NumberPlayboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiplePlayboardConfigCopyWith<$Res> {
  factory $MultiplePlayboardConfigCopyWith(MultiplePlayboardConfig value,
          $Res Function(MultiplePlayboardConfig) then) =
      _$MultiplePlayboardConfigCopyWithImpl<$Res>;
  $Res call({Map<String, PlayboardConfig> configs});
}

/// @nodoc
class _$MultiplePlayboardConfigCopyWithImpl<$Res>
    extends _$PlayboardConfigCopyWithImpl<$Res>
    implements $MultiplePlayboardConfigCopyWith<$Res> {
  _$MultiplePlayboardConfigCopyWithImpl(MultiplePlayboardConfig _value,
      $Res Function(MultiplePlayboardConfig) _then)
      : super(_value, (v) => _then(v as MultiplePlayboardConfig));

  @override
  MultiplePlayboardConfig get _value => super._value as MultiplePlayboardConfig;

  @override
  $Res call({
    Object? configs = freezed,
  }) {
    return _then(MultiplePlayboardConfig(
      configs == freezed
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<String, PlayboardConfig>,
    ));
  }
}

/// @nodoc

class _$MultiplePlayboardConfig implements MultiplePlayboardConfig {
  const _$MultiplePlayboardConfig(this.configs);

  @override
  final Map<String, PlayboardConfig> configs;

  @override
  String toString() {
    return 'PlayboardConfig.multiple(configs: $configs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MultiplePlayboardConfig &&
            const DeepCollectionEquality().equals(other.configs, configs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(configs));

  @JsonKey(ignore: true)
  @override
  $MultiplePlayboardConfigCopyWith<MultiplePlayboardConfig> get copyWith =>
      _$MultiplePlayboardConfigCopyWithImpl<MultiplePlayboardConfig>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(Map<String, PlayboardConfig> configs) multiple,
  }) {
    return multiple(configs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
  }) {
    return multiple?.call(configs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(Map<String, PlayboardConfig> configs)? multiple,
    required TResult orElse(),
  }) {
    if (multiple != null) {
      return multiple(configs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NonePlayboardConfig value) none,
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
  }) {
    return multiple(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
  }) {
    return multiple?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NonePlayboardConfig value)? none,
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    required TResult orElse(),
  }) {
    if (multiple != null) {
      return multiple(this);
    }
    return orElse();
  }
}

abstract class MultiplePlayboardConfig implements PlayboardConfig {
  const factory MultiplePlayboardConfig(Map<String, PlayboardConfig> configs) =
      _$MultiplePlayboardConfig;

  Map<String, PlayboardConfig> get configs;
  @JsonKey(ignore: true)
  $MultiplePlayboardConfigCopyWith<MultiplePlayboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
