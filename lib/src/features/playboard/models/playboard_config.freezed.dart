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

  MultiplePlayboardConfig multiple(List<PlayboardConfig> configs) {
    return MultiplePlayboardConfig(
      configs,
    );
  }

  OnlinePlayboardConfig online(
      [Map<PlayerColors, ButtonColors> configs = const {
        PlayerColors.blue: ButtonColors.blue,
        PlayerColors.red: ButtonColors.red,
        PlayerColors.yellow: ButtonColors.yellow,
        PlayerColors.green: ButtonColors.green
      }]) {
    return OnlinePlayboardConfig(
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
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(List<PlayboardConfig> configs) multiple,
    required TResult Function(Map<PlayerColors, ButtonColors> configs) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
    required TResult Function(OnlinePlayboardConfig value) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
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
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(List<PlayboardConfig> configs) multiple,
    required TResult Function(Map<PlayerColors, ButtonColors> configs) online,
  }) {
    return blind(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
  }) {
    return blind?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
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
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
    required TResult Function(OnlinePlayboardConfig value) online,
  }) {
    return blind(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
  }) {
    return blind?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
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
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(List<PlayboardConfig> configs) multiple,
    required TResult Function(Map<PlayerColors, ButtonColors> configs) online,
  }) {
    return number(color);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
  }) {
    return number?.call(color);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
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
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
    required TResult Function(OnlinePlayboardConfig value) online,
  }) {
    return number(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
  }) {
    return number?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
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
  $Res call({List<PlayboardConfig> configs});
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
              as List<PlayboardConfig>,
    ));
  }
}

/// @nodoc

class _$MultiplePlayboardConfig implements MultiplePlayboardConfig {
  const _$MultiplePlayboardConfig(this.configs);

  @override
  final List<PlayboardConfig> configs;

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
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(List<PlayboardConfig> configs) multiple,
    required TResult Function(Map<PlayerColors, ButtonColors> configs) online,
  }) {
    return multiple(configs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
  }) {
    return multiple?.call(configs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
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
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
    required TResult Function(OnlinePlayboardConfig value) online,
  }) {
    return multiple(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
  }) {
    return multiple?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
    required TResult orElse(),
  }) {
    if (multiple != null) {
      return multiple(this);
    }
    return orElse();
  }
}

abstract class MultiplePlayboardConfig implements PlayboardConfig {
  const factory MultiplePlayboardConfig(List<PlayboardConfig> configs) =
      _$MultiplePlayboardConfig;

  List<PlayboardConfig> get configs;
  @JsonKey(ignore: true)
  $MultiplePlayboardConfigCopyWith<MultiplePlayboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnlinePlayboardConfigCopyWith<$Res> {
  factory $OnlinePlayboardConfigCopyWith(OnlinePlayboardConfig value,
          $Res Function(OnlinePlayboardConfig) then) =
      _$OnlinePlayboardConfigCopyWithImpl<$Res>;
  $Res call({Map<PlayerColors, ButtonColors> configs});
}

/// @nodoc
class _$OnlinePlayboardConfigCopyWithImpl<$Res>
    extends _$PlayboardConfigCopyWithImpl<$Res>
    implements $OnlinePlayboardConfigCopyWith<$Res> {
  _$OnlinePlayboardConfigCopyWithImpl(
      OnlinePlayboardConfig _value, $Res Function(OnlinePlayboardConfig) _then)
      : super(_value, (v) => _then(v as OnlinePlayboardConfig));

  @override
  OnlinePlayboardConfig get _value => super._value as OnlinePlayboardConfig;

  @override
  $Res call({
    Object? configs = freezed,
  }) {
    return _then(OnlinePlayboardConfig(
      configs == freezed
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<PlayerColors, ButtonColors>,
    ));
  }
}

/// @nodoc

class _$OnlinePlayboardConfig implements OnlinePlayboardConfig {
  const _$OnlinePlayboardConfig(
      [this.configs = const {
        PlayerColors.blue: ButtonColors.blue,
        PlayerColors.red: ButtonColors.red,
        PlayerColors.yellow: ButtonColors.yellow,
        PlayerColors.green: ButtonColors.green
      }]);

  @JsonKey()
  @override
  final Map<PlayerColors, ButtonColors> configs;

  @override
  String toString() {
    return 'PlayboardConfig.online(configs: $configs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnlinePlayboardConfig &&
            const DeepCollectionEquality().equals(other.configs, configs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(configs));

  @JsonKey(ignore: true)
  @override
  $OnlinePlayboardConfigCopyWith<OnlinePlayboardConfig> get copyWith =>
      _$OnlinePlayboardConfigCopyWithImpl<OnlinePlayboardConfig>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ButtonColors color) blind,
    required TResult Function(ButtonColors color) number,
    required TResult Function(List<PlayboardConfig> configs) multiple,
    required TResult Function(Map<PlayerColors, ButtonColors> configs) online,
  }) {
    return online(configs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
  }) {
    return online?.call(configs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ButtonColors color)? blind,
    TResult Function(ButtonColors color)? number,
    TResult Function(List<PlayboardConfig> configs)? multiple,
    TResult Function(Map<PlayerColors, ButtonColors> configs)? online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(configs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BlindPlayboardConfig value) blind,
    required TResult Function(NumberPlayboardConfig value) number,
    required TResult Function(MultiplePlayboardConfig value) multiple,
    required TResult Function(OnlinePlayboardConfig value) online,
  }) {
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
  }) {
    return online?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BlindPlayboardConfig value)? blind,
    TResult Function(NumberPlayboardConfig value)? number,
    TResult Function(MultiplePlayboardConfig value)? multiple,
    TResult Function(OnlinePlayboardConfig value)? online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(this);
    }
    return orElse();
  }
}

abstract class OnlinePlayboardConfig implements PlayboardConfig {
  const factory OnlinePlayboardConfig(
      [Map<PlayerColors, ButtonColors> configs]) = _$OnlinePlayboardConfig;

  Map<PlayerColors, ButtonColors> get configs;
  @JsonKey(ignore: true)
  $OnlinePlayboardConfigCopyWith<OnlinePlayboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
