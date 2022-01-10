import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:slideparty/src/cores/db.dart';
import 'package:slideparty/src/utils/slideparty_colors.dart';

part 'slideparty_button_params.g.dart';

@HiveType(typeId: DbIdNumbering.buttonColorsId)
enum ButtonColors {
  @HiveField(0)
  blue,
  @HiveField(1)
  green,
  @HiveField(2)
  red,
  @HiveField(3)
  yellow,
}

extension BackgroundColor on ButtonColors {
  Color backgroundColor(BuildContext context) {
    switch (this) {
      case ButtonColors.blue:
        return Theme.of(context).brightness == Brightness.dark
            ? SlidepartyColors.dark.blueBg
            : SlidepartyColors.light.blueBg;
      case ButtonColors.green:
        return Theme.of(context).brightness == Brightness.dark
            ? SlidepartyColors.dark.greenBg
            : SlidepartyColors.light.greenBg;

      case ButtonColors.red:
        return Theme.of(context).brightness == Brightness.dark
            ? SlidepartyColors.dark.redBg
            : SlidepartyColors.light.redBg;

      case ButtonColors.yellow:
        return Theme.of(context).brightness == Brightness.dark
            ? SlidepartyColors.dark.yellowBg
            : SlidepartyColors.light.yellowBg;
      default:
        throw Exception('ButtonColors not found');
    }
  }
}

enum ButtonSize { large, square }
