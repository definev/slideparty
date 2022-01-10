import 'package:hive_flutter/hive_flutter.dart';

class DbCore<T> {
  late final Box<T> box;

  Future<void> init() async {
    box = await Hive.openBox(runtimeType.toString());
  }
}
