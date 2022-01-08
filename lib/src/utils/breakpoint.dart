import 'package:flutter/material.dart';

const screenBp = Breakpoint(small: 480, normal: 720, large: 1028);

class Breakpoint {
  final double small;
  final double normal;
  final double large;

  const Breakpoint({
    required this.small,
    required this.normal,
    required this.large,
  });

  T responsiveValue<T>(
    Size size, {
    T? watch,
    T? mobile,
    T? tablet,
    T? desktop,
    required T defaultValue,
  }) {
    // print(
    //   'CURRENT STATE:\n'
    //   ' | WATCH: ${size.shortestSide <= small} \n'
    //   ' | MOBILE: ${size.shortestSide <= normal} \n'
    //   ' | TABLET: ${size.shortestSide <= large} \n'
    //   ' | DESKTOP: ${size.shortestSide > large} \n',
    // );
    if (size.shortestSide <= small) return watch ?? defaultValue;
    if (size.shortestSide <= normal) return mobile ?? defaultValue;
    if (size.shortestSide <= large) return tablet ?? defaultValue;
    return desktop ?? defaultValue;
  }
}
