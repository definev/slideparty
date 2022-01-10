import 'package:flutter/material.dart';
import 'package:slideparty/app.dart';
import 'package:slideparty/bootstraps.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bootstraps(const App());
}
