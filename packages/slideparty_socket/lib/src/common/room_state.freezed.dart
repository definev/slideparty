// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'room_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RoomState _$RoomStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return RoomStateData.fromJson(json);
    case 'loading':
      return RoomStateLoading.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'RoomState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$RoomStateTearOff {
  const _$RoomStateTearOff();

  RoomStateData call(
      {required String code,
      @MapPlayerStateConverter() required Map<String, PlayerState> players}) {
    return RoomStateData(
      code: code,
      players: players,
    );
  }

  RoomStateLoading loading() {
    return RoomStateLoading();
  }

  RoomState fromJson(Map<String, Object?> json) {
    return RoomState.fromJson(json);
  }
}

/// @nodoc
const $RoomState = _$RoomStateTearOff();

/// @nodoc
mixin _$RoomState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)
        $default, {
    required TResult Function() loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RoomStateData value) $default, {
    required TResult Function(RoomStateLoading value) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomStateCopyWith<$Res> {
  factory $RoomStateCopyWith(RoomState value, $Res Function(RoomState) then) =
      _$RoomStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$RoomStateCopyWithImpl<$Res> implements $RoomStateCopyWith<$Res> {
  _$RoomStateCopyWithImpl(this._value, this._then);

  final RoomState _value;
  // ignore: unused_field
  final $Res Function(RoomState) _then;
}

/// @nodoc
abstract class $RoomStateDataCopyWith<$Res> {
  factory $RoomStateDataCopyWith(
          RoomStateData value, $Res Function(RoomStateData) then) =
      _$RoomStateDataCopyWithImpl<$Res>;
  $Res call(
      {String code,
      @MapPlayerStateConverter() Map<String, PlayerState> players});
}

/// @nodoc
class _$RoomStateDataCopyWithImpl<$Res> extends _$RoomStateCopyWithImpl<$Res>
    implements $RoomStateDataCopyWith<$Res> {
  _$RoomStateDataCopyWithImpl(
      RoomStateData _value, $Res Function(RoomStateData) _then)
      : super(_value, (v) => _then(v as RoomStateData));

  @override
  RoomStateData get _value => super._value as RoomStateData;

  @override
  $Res call({
    Object? code = freezed,
    Object? players = freezed,
  }) {
    return _then(RoomStateData(
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      players: players == freezed
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as Map<String, PlayerState>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomStateData implements RoomStateData {
  _$RoomStateData(
      {required this.code,
      @MapPlayerStateConverter() required this.players,
      String? $type})
      : $type = $type ?? 'default';

  factory _$RoomStateData.fromJson(Map<String, dynamic> json) =>
      _$$RoomStateDataFromJson(json);

  @override
  final String code;
  @override
  @MapPlayerStateConverter()
  final Map<String, PlayerState> players;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomState(code: $code, players: $players)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoomStateData &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality().equals(other.players, players));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(players));

  @JsonKey(ignore: true)
  @override
  $RoomStateDataCopyWith<RoomStateData> get copyWith =>
      _$RoomStateDataCopyWithImpl<RoomStateData>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)
        $default, {
    required TResult Function() loading,
  }) {
    return $default(code, players);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
  }) {
    return $default?.call(code, players);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(code, players);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RoomStateData value) $default, {
    required TResult Function(RoomStateLoading value) loading,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomStateDataToJson(this);
  }
}

abstract class RoomStateData implements RoomState {
  factory RoomStateData(
      {required String code,
      @MapPlayerStateConverter()
          required Map<String, PlayerState> players}) = _$RoomStateData;

  factory RoomStateData.fromJson(Map<String, dynamic> json) =
      _$RoomStateData.fromJson;

  String get code;
  @MapPlayerStateConverter()
  Map<String, PlayerState> get players;
  @JsonKey(ignore: true)
  $RoomStateDataCopyWith<RoomStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomStateLoadingCopyWith<$Res> {
  factory $RoomStateLoadingCopyWith(
          RoomStateLoading value, $Res Function(RoomStateLoading) then) =
      _$RoomStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class _$RoomStateLoadingCopyWithImpl<$Res> extends _$RoomStateCopyWithImpl<$Res>
    implements $RoomStateLoadingCopyWith<$Res> {
  _$RoomStateLoadingCopyWithImpl(
      RoomStateLoading _value, $Res Function(RoomStateLoading) _then)
      : super(_value, (v) => _then(v as RoomStateLoading));

  @override
  RoomStateLoading get _value => super._value as RoomStateLoading;
}

/// @nodoc
@JsonSerializable()
class _$RoomStateLoading implements RoomStateLoading {
  _$RoomStateLoading({String? $type}) : $type = $type ?? 'loading';

  factory _$RoomStateLoading.fromJson(Map<String, dynamic> json) =>
      _$$RoomStateLoadingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is RoomStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)
        $default, {
    required TResult Function() loading,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String code,
            @MapPlayerStateConverter() Map<String, PlayerState> players)?
        $default, {
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RoomStateData value) $default, {
    required TResult Function(RoomStateLoading value) loading,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RoomStateData value)? $default, {
    TResult Function(RoomStateLoading value)? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomStateLoadingToJson(this);
  }
}

abstract class RoomStateLoading implements RoomState {
  factory RoomStateLoading() = _$RoomStateLoading;

  factory RoomStateLoading.fromJson(Map<String, dynamic> json) =
      _$RoomStateLoading.fromJson;
}
