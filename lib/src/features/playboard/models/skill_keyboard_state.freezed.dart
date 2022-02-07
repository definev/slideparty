// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'skill_keyboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SkillKeyboardState _$SkillKeyboardStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'inGame':
      return SkillInGameState.fromJson(json);
    case 'online':
      return SkillOnlineState.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'SkillKeyboardState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
class _$SkillKeyboardStateTearOff {
  const _$SkillKeyboardStateTearOff();

  SkillInGameState inGame(
      {required String playerId,
      bool show = false,
      Map<SlidepartyActions, bool> usedActions =
          const <SlidepartyActions, bool>{},
      SlidepartyActions? queuedAction}) {
    return SkillInGameState(
      playerId: playerId,
      show: show,
      usedActions: usedActions,
      queuedAction: queuedAction,
    );
  }

  SkillOnlineState online(
      {bool show = false,
      Map<SlidepartyActions, bool> usedActions =
          const <SlidepartyActions, bool>{},
      SlidepartyActions? queuedAction}) {
    return SkillOnlineState(
      show: show,
      usedActions: usedActions,
      queuedAction: queuedAction,
    );
  }

  SkillKeyboardState fromJson(Map<String, Object?> json) {
    return SkillKeyboardState.fromJson(json);
  }
}

/// @nodoc
const $SkillKeyboardState = _$SkillKeyboardStateTearOff();

/// @nodoc
mixin _$SkillKeyboardState {
  bool get show => throw _privateConstructorUsedError;
  Map<SlidepartyActions, bool> get usedActions =>
      throw _privateConstructorUsedError;
  SlidepartyActions? get queuedAction => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        inGame,
    required TResult Function(
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SkillInGameState value) inGame,
    required TResult Function(SkillOnlineState value) online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkillKeyboardStateCopyWith<SkillKeyboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillKeyboardStateCopyWith<$Res> {
  factory $SkillKeyboardStateCopyWith(
          SkillKeyboardState value, $Res Function(SkillKeyboardState) then) =
      _$SkillKeyboardStateCopyWithImpl<$Res>;
  $Res call(
      {bool show,
      Map<SlidepartyActions, bool> usedActions,
      SlidepartyActions? queuedAction});
}

/// @nodoc
class _$SkillKeyboardStateCopyWithImpl<$Res>
    implements $SkillKeyboardStateCopyWith<$Res> {
  _$SkillKeyboardStateCopyWithImpl(this._value, this._then);

  final SkillKeyboardState _value;
  // ignore: unused_field
  final $Res Function(SkillKeyboardState) _then;

  @override
  $Res call({
    Object? show = freezed,
    Object? usedActions = freezed,
    Object? queuedAction = freezed,
  }) {
    return _then(_value.copyWith(
      show: show == freezed
          ? _value.show
          : show // ignore: cast_nullable_to_non_nullable
              as bool,
      usedActions: usedActions == freezed
          ? _value.usedActions
          : usedActions // ignore: cast_nullable_to_non_nullable
              as Map<SlidepartyActions, bool>,
      queuedAction: queuedAction == freezed
          ? _value.queuedAction
          : queuedAction // ignore: cast_nullable_to_non_nullable
              as SlidepartyActions?,
    ));
  }
}

/// @nodoc
abstract class $SkillInGameStateCopyWith<$Res>
    implements $SkillKeyboardStateCopyWith<$Res> {
  factory $SkillInGameStateCopyWith(
          SkillInGameState value, $Res Function(SkillInGameState) then) =
      _$SkillInGameStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String playerId,
      bool show,
      Map<SlidepartyActions, bool> usedActions,
      SlidepartyActions? queuedAction});
}

/// @nodoc
class _$SkillInGameStateCopyWithImpl<$Res>
    extends _$SkillKeyboardStateCopyWithImpl<$Res>
    implements $SkillInGameStateCopyWith<$Res> {
  _$SkillInGameStateCopyWithImpl(
      SkillInGameState _value, $Res Function(SkillInGameState) _then)
      : super(_value, (v) => _then(v as SkillInGameState));

  @override
  SkillInGameState get _value => super._value as SkillInGameState;

  @override
  $Res call({
    Object? playerId = freezed,
    Object? show = freezed,
    Object? usedActions = freezed,
    Object? queuedAction = freezed,
  }) {
    return _then(SkillInGameState(
      playerId: playerId == freezed
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as String,
      show: show == freezed
          ? _value.show
          : show // ignore: cast_nullable_to_non_nullable
              as bool,
      usedActions: usedActions == freezed
          ? _value.usedActions
          : usedActions // ignore: cast_nullable_to_non_nullable
              as Map<SlidepartyActions, bool>,
      queuedAction: queuedAction == freezed
          ? _value.queuedAction
          : queuedAction // ignore: cast_nullable_to_non_nullable
              as SlidepartyActions?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillInGameState implements SkillInGameState {
  const _$SkillInGameState(
      {required this.playerId,
      this.show = false,
      this.usedActions = const <SlidepartyActions, bool>{},
      this.queuedAction,
      String? $type})
      : $type = $type ?? 'inGame';

  factory _$SkillInGameState.fromJson(Map<String, dynamic> json) =>
      _$$SkillInGameStateFromJson(json);

  @override
  final String playerId;
  @JsonKey()
  @override
  final bool show;
  @JsonKey()
  @override
  final Map<SlidepartyActions, bool> usedActions;
  @override
  final SlidepartyActions? queuedAction;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SkillKeyboardState.inGame(playerId: $playerId, show: $show, usedActions: $usedActions, queuedAction: $queuedAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkillInGameState &&
            const DeepCollectionEquality().equals(other.playerId, playerId) &&
            const DeepCollectionEquality().equals(other.show, show) &&
            const DeepCollectionEquality()
                .equals(other.usedActions, usedActions) &&
            const DeepCollectionEquality()
                .equals(other.queuedAction, queuedAction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(playerId),
      const DeepCollectionEquality().hash(show),
      const DeepCollectionEquality().hash(usedActions),
      const DeepCollectionEquality().hash(queuedAction));

  @JsonKey(ignore: true)
  @override
  $SkillInGameStateCopyWith<SkillInGameState> get copyWith =>
      _$SkillInGameStateCopyWithImpl<SkillInGameState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        inGame,
    required TResult Function(
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        online,
  }) {
    return inGame(playerId, show, usedActions, queuedAction);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
  }) {
    return inGame?.call(playerId, show, usedActions, queuedAction);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
    required TResult orElse(),
  }) {
    if (inGame != null) {
      return inGame(playerId, show, usedActions, queuedAction);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SkillInGameState value) inGame,
    required TResult Function(SkillOnlineState value) online,
  }) {
    return inGame(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
  }) {
    return inGame?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
    required TResult orElse(),
  }) {
    if (inGame != null) {
      return inGame(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillInGameStateToJson(this);
  }
}

abstract class SkillInGameState implements SkillKeyboardState {
  const factory SkillInGameState(
      {required String playerId,
      bool show,
      Map<SlidepartyActions, bool> usedActions,
      SlidepartyActions? queuedAction}) = _$SkillInGameState;

  factory SkillInGameState.fromJson(Map<String, dynamic> json) =
      _$SkillInGameState.fromJson;

  String get playerId;
  @override
  bool get show;
  @override
  Map<SlidepartyActions, bool> get usedActions;
  @override
  SlidepartyActions? get queuedAction;
  @override
  @JsonKey(ignore: true)
  $SkillInGameStateCopyWith<SkillInGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillOnlineStateCopyWith<$Res>
    implements $SkillKeyboardStateCopyWith<$Res> {
  factory $SkillOnlineStateCopyWith(
          SkillOnlineState value, $Res Function(SkillOnlineState) then) =
      _$SkillOnlineStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool show,
      Map<SlidepartyActions, bool> usedActions,
      SlidepartyActions? queuedAction});
}

/// @nodoc
class _$SkillOnlineStateCopyWithImpl<$Res>
    extends _$SkillKeyboardStateCopyWithImpl<$Res>
    implements $SkillOnlineStateCopyWith<$Res> {
  _$SkillOnlineStateCopyWithImpl(
      SkillOnlineState _value, $Res Function(SkillOnlineState) _then)
      : super(_value, (v) => _then(v as SkillOnlineState));

  @override
  SkillOnlineState get _value => super._value as SkillOnlineState;

  @override
  $Res call({
    Object? show = freezed,
    Object? usedActions = freezed,
    Object? queuedAction = freezed,
  }) {
    return _then(SkillOnlineState(
      show: show == freezed
          ? _value.show
          : show // ignore: cast_nullable_to_non_nullable
              as bool,
      usedActions: usedActions == freezed
          ? _value.usedActions
          : usedActions // ignore: cast_nullable_to_non_nullable
              as Map<SlidepartyActions, bool>,
      queuedAction: queuedAction == freezed
          ? _value.queuedAction
          : queuedAction // ignore: cast_nullable_to_non_nullable
              as SlidepartyActions?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillOnlineState implements SkillOnlineState {
  const _$SkillOnlineState(
      {this.show = false,
      this.usedActions = const <SlidepartyActions, bool>{},
      this.queuedAction,
      String? $type})
      : $type = $type ?? 'online';

  factory _$SkillOnlineState.fromJson(Map<String, dynamic> json) =>
      _$$SkillOnlineStateFromJson(json);

  @JsonKey()
  @override
  final bool show;
  @JsonKey()
  @override
  final Map<SlidepartyActions, bool> usedActions;
  @override
  final SlidepartyActions? queuedAction;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'SkillKeyboardState.online(show: $show, usedActions: $usedActions, queuedAction: $queuedAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SkillOnlineState &&
            const DeepCollectionEquality().equals(other.show, show) &&
            const DeepCollectionEquality()
                .equals(other.usedActions, usedActions) &&
            const DeepCollectionEquality()
                .equals(other.queuedAction, queuedAction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(show),
      const DeepCollectionEquality().hash(usedActions),
      const DeepCollectionEquality().hash(queuedAction));

  @JsonKey(ignore: true)
  @override
  $SkillOnlineStateCopyWith<SkillOnlineState> get copyWith =>
      _$SkillOnlineStateCopyWithImpl<SkillOnlineState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        inGame,
    required TResult Function(
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)
        online,
  }) {
    return online(show, usedActions, queuedAction);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
  }) {
    return online?.call(show, usedActions, queuedAction);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String playerId,
            bool show,
            Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        inGame,
    TResult Function(bool show, Map<SlidepartyActions, bool> usedActions,
            SlidepartyActions? queuedAction)?
        online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(show, usedActions, queuedAction);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SkillInGameState value) inGame,
    required TResult Function(SkillOnlineState value) online,
  }) {
    return online(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
  }) {
    return online?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SkillInGameState value)? inGame,
    TResult Function(SkillOnlineState value)? online,
    required TResult orElse(),
  }) {
    if (online != null) {
      return online(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillOnlineStateToJson(this);
  }
}

abstract class SkillOnlineState implements SkillKeyboardState {
  const factory SkillOnlineState(
      {bool show,
      Map<SlidepartyActions, bool> usedActions,
      SlidepartyActions? queuedAction}) = _$SkillOnlineState;

  factory SkillOnlineState.fromJson(Map<String, dynamic> json) =
      _$SkillOnlineState.fromJson;

  @override
  bool get show;
  @override
  Map<SlidepartyActions, bool> get usedActions;
  @override
  SlidepartyActions? get queuedAction;
  @override
  @JsonKey(ignore: true)
  $SkillOnlineStateCopyWith<SkillOnlineState> get copyWith =>
      throw _privateConstructorUsedError;
}
