import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/providers/app_theme_mode_provider.dart';
import 'core/theme/providers/app_theme_provider.dart';
import 'pages/home_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final appTheme = ref.watch(appThemeProvider);
    final appThemeMode = ref.watch(appThemeModeProvider).asData?.value;

    return MaterialApp(
      title: 'Test',
      theme: appTheme.getThemeData(isLightTheme: true),
      darkTheme: appTheme.getThemeData(isLightTheme: false),
      themeMode: appThemeMode,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
