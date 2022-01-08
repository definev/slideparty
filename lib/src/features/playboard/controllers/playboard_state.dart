import 'package:slideparty/src/features/playboard/models/playboard_config.dart';

abstract class PlayboardState {
  final PlayboardConfig config;

  PlayboardState({required this.config});
}
