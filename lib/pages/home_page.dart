import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/providers/app_theme_mode_provider.dart';
import '../core/theme/providers/toggle_theme_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final isLightTheme = ref.watch(appThemeModeProvider).asData?.value == ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(
            isLightTheme ? Icons.dark_mode : Icons.light_mode,
            size: 50,
          ),
          onPressed: () {
            ref.read(toggleThemeProvider);
          },
        ),
      ),
    );
  }
}
