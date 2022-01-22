// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'player_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PlayerEventTearOff {
  const _$PlayerEventTearOff();

  SendName sendName(String name) {
    return SendName(
      name,
    );
  }

  SendBoard sendBoard(List<int> board) {
    return SendBoard(
      board,
    );
  }

  SendAction sendAction(String affectedPlayerId, SlidepartyActions action) {
    return SendAction(
      affectedPlayerId,
      action,
    );
  }
}

/// @nodoc
const $PlayerEvent = _$PlayerEventTearOff();

/// @nodoc
mixin _$PlayerEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) sendName,
    required TResult Function(List<int> board) sendBoard,
    required TResult Function(String affectedPlayerId, SlidepartyActions action)
        sendAction,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendName value) sendName,
    required TResult Function(SendBoard value) sendBoard,
    required TResult Function(SendAction value) sendAction,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerEventCopyWith<$Res> {
  factory $PlayerEventCopyWith(
          PlayerEvent value, $Res Function(PlayerEvent) then) =
      _$PlayerEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$PlayerEventCopyWithImpl<$Res> implements $PlayerEventCopyWith<$Res> {
  _$PlayerEventCopyWithImpl(this._value, this._then);

  final PlayerEvent _value;
  // ignore: unused_field
  final $Res Function(PlayerEvent) _then;
}

/// @nodoc
abstract class $SendNameCopyWith<$Res> {
  factory $SendNameCopyWith(SendName value, $Res Function(SendName) then) =
      _$SendNameCopyWithImpl<$Res>;
  $Res call({String name});
}

/// @nodoc
class _$SendNameCopyWithImpl<$Res> extends _$PlayerEventCopyWithImpl<$Res>
    implements $SendNameCopyWith<$Res> {
  _$SendNameCopyWithImpl(SendName _value, $Res Function(SendName) _then)
      : super(_value, (v) => _then(v as SendName));

  @override
  SendName get _value => super._value as SendName;

  @override
  $Res call({
    Object? name = freezed,
  }) {
    return _then(SendName(
      name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SendName implements SendName {
  const _$SendName(this.name);

  @override
  final String name;

  @override
  String toString() {
    return 'PlayerEvent.sendName(name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendName &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  $SendNameCopyWith<SendName> get copyWith =>
      _$SendNameCopyWithImpl<SendName>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) sendName,
    required TResult Function(List<int> board) sendBoard,
    required TResult Function(String affectedPlayerId, SlidepartyActions action)
        sendAction,
  }) {
    return sendName(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
  }) {
    return sendName?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
    required TResult orElse(),
  }) {
    if (sendName != null) {
      return sendName(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendName value) sendName,
    required TResult Function(SendBoard value) sendBoard,
    required TResult Function(SendAction value) sendAction,
  }) {
    return sendName(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
  }) {
    return sendName?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
    required TResult orElse(),
  }) {
    if (sendName != null) {
      return sendName(this);
    }
    return orElse();
  }
}

abstract class SendName implements PlayerEvent {
  const factory SendName(String name) = _$SendName;

  String get name;
  @JsonKey(ignore: true)
  $SendNameCopyWith<SendName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendBoardCopyWith<$Res> {
  factory $SendBoardCopyWith(SendBoard value, $Res Function(SendBoard) then) =
      _$SendBoardCopyWithImpl<$Res>;
  $Res call({List<int> board});
}

/// @nodoc
class _$SendBoardCopyWithImpl<$Res> extends _$PlayerEventCopyWithImpl<$Res>
    implements $SendBoardCopyWith<$Res> {
  _$SendBoardCopyWithImpl(SendBoard _value, $Res Function(SendBoard) _then)
      : super(_value, (v) => _then(v as SendBoard));

  @override
  SendBoard get _value => super._value as SendBoard;

  @override
  $Res call({
    Object? board = freezed,
  }) {
    return _then(SendBoard(
      board == freezed
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$SendBoard implements SendBoard {
  const _$SendBoard(this.board);

  @override
  final List<int> board;

  @override
  String toString() {
    return 'PlayerEvent.sendBoard(board: $board)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendBoard &&
            const DeepCollectionEquality().equals(other.board, board));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(board));

  @JsonKey(ignore: true)
  @override
  $SendBoardCopyWith<SendBoard> get copyWith =>
      _$SendBoardCopyWithImpl<SendBoard>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) sendName,
    required TResult Function(List<int> board) sendBoard,
    required TResult Function(String affectedPlayerId, SlidepartyActions action)
        sendAction,
  }) {
    return sendBoard(board);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
  }) {
    return sendBoard?.call(board);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
    required TResult orElse(),
  }) {
    if (sendBoard != null) {
      return sendBoard(board);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendName value) sendName,
    required TResult Function(SendBoard value) sendBoard,
    required TResult Function(SendAction value) sendAction,
  }) {
    return sendBoard(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
  }) {
    return sendBoard?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
    required TResult orElse(),
  }) {
    if (sendBoard != null) {
      return sendBoard(this);
    }
    return orElse();
  }
}

abstract class SendBoard implements PlayerEvent {
  const factory SendBoard(List<int> board) = _$SendBoard;

  List<int> get board;
  @JsonKey(ignore: true)
  $SendBoardCopyWith<SendBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendActionCopyWith<$Res> {
  factory $SendActionCopyWith(
          SendAction value, $Res Function(SendAction) then) =
      _$SendActionCopyWithImpl<$Res>;
  $Res call({String affectedPlayerId, SlidepartyActions action});
}

/// @nodoc
class _$SendActionCopyWithImpl<$Res> extends _$PlayerEventCopyWithImpl<$Res>
    implements $SendActionCopyWith<$Res> {
  _$SendActionCopyWithImpl(SendAction _value, $Res Function(SendAction) _then)
      : super(_value, (v) => _then(v as SendAction));

  @override
  SendAction get _value => super._value as SendAction;

  @override
  $Res call({
    Object? affectedPlayerId = freezed,
    Object? action = freezed,
  }) {
    return _then(SendAction(
      affectedPlayerId == freezed
          ? _value.affectedPlayerId
          : affectedPlayerId // ignore: cast_nullable_to_non_nullable
              as String,
      action == freezed
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as SlidepartyActions,
    ));
  }
}

/// @nodoc

class _$SendAction implements SendAction {
  const _$SendAction(this.affectedPlayerId, this.action);

  @override
  final String affectedPlayerId;
  @override
  final SlidepartyActions action;

  @override
  String toString() {
    return 'PlayerEvent.sendAction(affectedPlayerId: $affectedPlayerId, action: $action)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendAction &&
            const DeepCollectionEquality()
                .equals(other.affectedPlayerId, affectedPlayerId) &&
            const DeepCollectionEquality().equals(other.action, action));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(affectedPlayerId),
      const DeepCollectionEquality().hash(action));

  @JsonKey(ignore: true)
  @override
  $SendActionCopyWith<SendAction> get copyWith =>
      _$SendActionCopyWithImpl<SendAction>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name) sendName,
    required TResult Function(List<int> board) sendBoard,
    required TResult Function(String affectedPlayerId, SlidepartyActions action)
        sendAction,
  }) {
    return sendAction(affectedPlayerId, action);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
  }) {
    return sendAction?.call(affectedPlayerId, action);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name)? sendName,
    TResult Function(List<int> board)? sendBoard,
    TResult Function(String affectedPlayerId, SlidepartyActions action)?
        sendAction,
    required TResult orElse(),
  }) {
    if (sendAction != null) {
      return sendAction(affectedPlayerId, action);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendName value) sendName,
    required TResult Function(SendBoard value) sendBoard,
    required TResult Function(SendAction value) sendAction,
  }) {
    return sendAction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
  }) {
    return sendAction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendName value)? sendName,
    TResult Function(SendBoard value)? sendBoard,
    TResult Function(SendAction value)? sendAction,
    required TResult orElse(),
  }) {
    if (sendAction != null) {
      return sendAction(this);
    }
    return orElse();
  }
}

abstract class SendAction implements PlayerEvent {
  const factory SendAction(String affectedPlayerId, SlidepartyActions action) =
      _$SendAction;

  String get affectedPlayerId;
  SlidepartyActions get action;
  @JsonKey(ignore: true)
  $SendActionCopyWith<SendAction> get copyWith =>
      throw _privateConstructorUsedError;
}
