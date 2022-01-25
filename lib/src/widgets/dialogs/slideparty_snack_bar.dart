import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showSlidepartyToast(
  BuildContext context,
  String text,
  double width,
) {
  showToastWidget(
    Container(
      height: 49,
      width: width,
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadows: const [BoxShadow()],
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    ),
    context: context,
    animation: StyledToastAnimation.slideFromBottom,
    reverseAnimation: StyledToastAnimation.slideFromBottom,
    isHideKeyboard: true,
    duration: const Duration(seconds: 1, milliseconds: 500),
    curve: Curves.decelerate,
  );
}
