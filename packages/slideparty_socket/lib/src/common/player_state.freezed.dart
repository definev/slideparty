// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) {
  return PlayerStateData.fromJson(json);
}

/// @nodoc
class _$PlayerStateTearOff {
  const _$PlayerStateTearOff();

  PlayerStateData call(
      {required String currentBoard,
      required PlayerColors color,
      required String name,
      required Map<String, SlidepartyActions> affectedActions,
      required List<SlidepartyActions> usedActions}) {
    return PlayerStateData(
      currentBoard: currentBoard,
      color: color,
      name: name,
      affectedActions: affectedActions,
      usedActions: usedActions,
    );
  }

  PlayerState fromJson(Map<String, Object?> json) {
    return PlayerState.fromJson(json);
  }
}

/// @nodoc
const $PlayerState = _$PlayerStateTearOff();

/// @nodoc
mixin _$PlayerState {
  String get currentBoard => throw _privateConstructorUsedError;
  PlayerColors get color => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, SlidepartyActions> get affectedActions =>
      throw _privateConstructorUsedError;
  List<SlidepartyActions> get usedActions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res>;
  $Res call(
      {String currentBoard,
      PlayerColors color,
      String name,
      Map<String, SlidepartyActions> affectedActions,
      List<SlidepartyActions> usedActions});
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res> implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  final PlayerState _value;
  // ignore: unused_field
  final $Res Function(PlayerState) _then;

  @override
  $Res call({
    Object? currentBoard = freezed,
    Object? color = freezed,
    Object? name = freezed,
    Object? affectedActions = freezed,
    Object? usedActions = freezed,
  }) {
    return _then(_value.copyWith(
      currentBoard: currentBoard == freezed
          ? _value.currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as PlayerColors,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      affectedActions: affectedActions == freezed
          ? _value.affectedActions
          : affectedActions // ignore: cast_nullable_to_non_nullable
              as Map<String, SlidepartyActions>,
      usedActions: usedActions == freezed
          ? _value.usedActions
          : usedActions // ignore: cast_nullable_to_non_nullable
              as List<SlidepartyActions>,
    ));
  }
}

/// @nodoc
abstract class $PlayerStateDataCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory $PlayerStateDataCopyWith(
          PlayerStateData value, $Res Function(PlayerStateData) then) =
      _$PlayerStateDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String currentBoard,
      PlayerColors color,
      String name,
      Map<String, SlidepartyActions> affectedActions,
      List<SlidepartyActions> usedActions});
}

/// @nodoc
class _$PlayerStateDataCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateDataCopyWith<$Res> {
  _$PlayerStateDataCopyWithImpl(
      PlayerStateData _value, $Res Function(PlayerStateData) _then)
      : super(_value, (v) => _then(v as PlayerStateData));

  @override
  PlayerStateData get _value => super._value as PlayerStateData;

  @override
  $Res call({
    Object? currentBoard = freezed,
    Object? color = freezed,
    Object? name = freezed,
    Object? affectedActions = freezed,
    Object? usedActions = freezed,
  }) {
    return _then(PlayerStateData(
      currentBoard: currentBoard == freezed
          ? _value.currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as PlayerColors,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      affectedActions: affectedActions == freezed
          ? _value.affectedActions
          : affectedActions // ignore: cast_nullable_to_non_nullable
              as Map<String, SlidepartyActions>,
      usedActions: usedActions == freezed
          ? _value.usedActions
          : usedActions // ignore: cast_nullable_to_non_nullable
              as List<SlidepartyActions>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStateData implements PlayerStateData {
  _$PlayerStateData(
      {required this.currentBoard,
      required this.color,
      required this.name,
      required this.affectedActions,
      required this.usedActions});

  factory _$PlayerStateData.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStateDataFromJson(json);

  @override
  final String currentBoard;
  @override
  final PlayerColors color;
  @override
  final String name;
  @override
  final Map<String, SlidepartyActions> affectedActions;
  @override
  final List<SlidepartyActions> usedActions;

  @override
  String toString() {
    return 'PlayerState(currentBoard: $currentBoard, color: $color, name: $name, affectedActions: $affectedActions, usedActions: $usedActions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlayerStateData &&
            const DeepCollectionEquality()
                .equals(other.currentBoard, currentBoard) &&
            const DeepCollectionEquality().equals(other.color, color) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.affectedActions, affectedActions) &&
            const DeepCollectionEquality()
                .equals(other.usedActions, usedActions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(currentBoard),
      const DeepCollectionEquality().hash(color),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(affectedActions),
      const DeepCollectionEquality().hash(usedActions));

  @JsonKey(ignore: true)
  @override
  $PlayerStateDataCopyWith<PlayerStateData> get copyWith =>
      _$PlayerStateDataCopyWithImpl<PlayerStateData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStateDataToJson(this);
  }
}

abstract class PlayerStateData implements PlayerState {
  factory PlayerStateData(
      {required String currentBoard,
      required PlayerColors color,
      required String name,
      required Map<String, SlidepartyActions> affectedActions,
      required List<SlidepartyActions> usedActions}) = _$PlayerStateData;

  factory PlayerStateData.fromJson(Map<String, dynamic> json) =
      _$PlayerStateData.fromJson;

  @override
  String get currentBoard;
  @override
  PlayerColors get color;
  @override
  String get name;
  @override
  Map<String, SlidepartyActions> get affectedActions;
  @override
  List<SlidepartyActions> get usedActions;
  @override
  @JsonKey(ignore: true)
  $PlayerStateDataCopyWith<PlayerStateData> get copyWith =>
      throw _privateConstructorUsedError;
}
