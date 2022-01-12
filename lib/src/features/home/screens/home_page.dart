import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slideparty/src/features/home/widgets/theme_setting_bar.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text.rich(
                TextSpan(
                  text: 'Slide',
                  children: [
                    TextSpan(
                      text: 'party',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Column(
              children: [
                SlidepartyButton(
                  color: ButtonColors.blue,
                  onPressed: () => context.go('/s_mode'),
                  child: const Text('Single Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColors.green,
                  onPressed: () => context.go('/m_mode'),
                  child: const Text('Multiple Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColors.red,
                  onPressed: () => context.go('/o_mode'),
                  child: const Text('Online Mode'),
                ),
              ],
            ),
            const ThemeSettingBar(),
          ],
        ),
      ),
    );
  }
}
