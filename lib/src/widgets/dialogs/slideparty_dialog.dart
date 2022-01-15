import 'package:flutter/material.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class SlidepartyDialog extends StatelessWidget {
  const SlidepartyDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: BorderSlidepartyPainter(
          edge: 6,
          thickness: 2,
          brightness: Theme.of(context).brightness,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SizedBox(
          height: 200,
          width: 300,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(child: Center(child: Text('YOU WIN !!!'))),
                  SlidepartyButton(
                    color: ButtonColors.yellow,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
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
