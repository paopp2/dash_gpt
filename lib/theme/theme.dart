import 'package:flutter/material.dart';

class AppTheme {
  static get light {
    return ThemeData.from(
      colorScheme: const ColorScheme.light(),
      useMaterial3: true,
    );
  }

  static get dark {
    return ThemeData.from(
      colorScheme: const ColorScheme.dark(),
      useMaterial3: true,
    );
  }
}
