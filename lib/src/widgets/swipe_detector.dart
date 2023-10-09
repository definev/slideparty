import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Creates a widget to detect swipe gestures on the screen :
/// swipe up, swipe down, swipe left and swipe right.
class SwipeDetector extends StatelessWidget {
  /// The widget below this widget in the tree
  final Widget child;

  /// Callback function to be called when swiping up
  final VoidCallback? onSwipeUp;

  /// Callback function to be called when swiping down
  final VoidCallback? onSwipeDown;

  /// Callback function to be called when swiping left
  final VoidCallback? onSwipeLeft;

  /// Callback function to be called when swiping right
  final VoidCallback? onSwipeRight;

  /// Default: 50
  final double verticalMaxWidthThreshold;

  /// mininum displacement of pointer on the vertical axis
  /// to be counted as a swipe
  ///
  /// Default: 100
  final double verticalMinDisplacement;

  /// minimum absolute velocity of pointer moving on the vertical axis
  /// to be counted as a swipe
  ///
  /// Default: 300
  final double verticalMinVelocity;

  /// Default: 50
  final double horizontalMaxHeightThreshold;

  /// mininum displacement of pointer on the horizontal axis
  /// to be counted as a swipe
  ///
  /// Default: 100
  final double horizontalMinDisplacement;

  /// minimum absolute velocity of pointer moving on the horizontal axis
  /// to be counted as a swipe
  ///
  /// Default: 300
  final double horizontalMinVelocity;

  const SwipeDetector({
    Key? key,
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.verticalMaxWidthThreshold = 300,
    this.verticalMinDisplacement = 10,
    this.verticalMinVelocity = 150,
    this.horizontalMaxHeightThreshold = 300,
    this.horizontalMinDisplacement = 10,
    this.horizontalMinVelocity = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DragStartDetails? startVerticalDragDetails;
    DragUpdateDetails? updateVerticalDragDetails;

    DragStartDetails? startHorizontalDragDetails;
    DragUpdateDetails? updateHorizontalDragDetails;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;
      },
      onVerticalDragEnd: (endDetails) {
        if (startVerticalDragDetails != null &&
            updateVerticalDragDetails != null) {
          double dx = (updateVerticalDragDetails!.globalPosition.dx -
                  startVerticalDragDetails!.globalPosition.dx)
              .abs();
          double dy = (updateVerticalDragDetails!.globalPosition.dy -
                  startVerticalDragDetails!.globalPosition.dy)
              .abs();
          double velocity = endDetails.primaryVelocity ?? 0.0;

          if (dx > verticalMaxWidthThreshold) return;
          if (dy < verticalMinDisplacement) return;
          if (velocity.abs() < verticalMinVelocity) return;

          if (velocity < 0) {
            //Swipe Up
            onSwipeUp?.call();
          }

          if (velocity > 0) {
            //Swipe Down
            onSwipeDown?.call();
          }
        }
      },
      onHorizontalDragStart: (dragDetails) {
        startHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragUpdate: (dragDetails) {
        updateHorizontalDragDetails = dragDetails;
      },
      onHorizontalDragEnd: (endDetails) {
        if (startHorizontalDragDetails != null &&
            updateHorizontalDragDetails != null) {
          double dx = (updateHorizontalDragDetails!.globalPosition.dx -
                  startHorizontalDragDetails!.globalPosition.dx)
              .abs();
          double dy = (updateHorizontalDragDetails!.globalPosition.dy -
                  startHorizontalDragDetails!.globalPosition.dy)
              .abs();
          double velocity = endDetails.primaryVelocity ?? 0.0;

          if (dy > horizontalMaxHeightThreshold) return;
          if (dx < horizontalMinDisplacement) return;
          if (velocity.abs() < horizontalMinVelocity) return;

          if (velocity < 0) {
            //Swipe Left
            onSwipeLeft?.call();
          }

          if (velocity > 0) {
            //Swipe Right
            onSwipeRight?.call();
          }
        }
      },
      child: child,
    );
  }
}
