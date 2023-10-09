import 'package:flutter/material.dart';

import 'package:slideparty/src/widgets/widgets.dart';

class SlidepartyDialog extends StatelessWidget {
  const SlidepartyDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
    this.height,
    this.width,
  }) : super(key: key);

  final String title;
  final Widget content;
  final List<Widget> actions;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomPaint(
        painter: BorderSlidepartyPainter(
          edge: 6,
          thickness: 2,
          brightness: Theme.of(context).brightness,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SizedBox(
          height: height ?? 200,
          width: width ?? double.maxFinite,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                      child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  )),
                  Expanded(child: Center(child: content)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: actions,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
