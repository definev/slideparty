import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/audio/button_audio_controller.dart';

enum ButtonColor { blue, green, red, yellow }
enum ButtonSize { large, square }
enum _ButtonState { hover, idle, pressed }

class SlidepartyButton extends HookConsumerWidget {
  const SlidepartyButton({
    Key? key,
    required this.color,
    this.size = ButtonSize.large,
    this.scale = 1,
    this.fontSize = 14,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final ButtonColor color;
  final ButtonSize size;
  final double fontSize;
  final VoidCallback onPressed;
  final Widget child;
  final double scale;

  String _imagePath(_ButtonState state) {
    String path = 'assets/buttons/';
    path += color.name;
    path += '_${state.name}';
    path += '_${size.name}';
    path += '_button.png';
    return path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonState = useState(_ButtonState.idle);
    final audioController = ref.read(buttonAudioControllerProvider);

    return MouseRegion(
      onEnter: (_) => buttonState.value = _ButtonState.hover,
      onExit: (_) => buttonState.value = _ButtonState.idle,
      child: GestureDetector(
        onTapDown: (_) => buttonState.value = _ButtonState.pressed,
        onTapUp: (_) => buttonState.value = _ButtonState.idle,
        onTapCancel: () => buttonState.value = _ButtonState.idle,
        onTap: () {
          audioController.clickSound();
          onPressed();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_imagePath(buttonState.value)),
              scale: 1 / scale,
            ),
          ),
          child: IconTheme(
            data: IconThemeData(
              color: buttonState.value == _ButtonState.hover
                  ? Colors.black
                  : Colors.white,
            ),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: fontSize,
                    color: buttonState.value == _ButtonState.hover
                        ? Colors.black
                        : Colors.white,
                  ),
              child: SizedBox(
                height: 49 * scale,
                width: size == ButtonSize.square ? (49 * scale) : 190,
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
