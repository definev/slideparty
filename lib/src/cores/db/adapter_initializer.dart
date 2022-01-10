import 'package:hive_flutter/hive_flutter.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';

class AdapterIntializer {
  static void initialize() {
    Hive.registerAdapter<ButtonColors>(ButtonColorsAdapter());
  }
}
