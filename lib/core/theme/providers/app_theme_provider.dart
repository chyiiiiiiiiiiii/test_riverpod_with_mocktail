import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_theme.dart';

final appThemeProvider = Provider((ref) {
  return AppTheme();
});
