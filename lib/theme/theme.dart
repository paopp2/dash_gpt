import 'package:flutter/material.dart';

class AppTheme {
  static get light {
    return ThemeData.from(
      colorScheme: const ColorScheme.light(),
    );
  }

  static get dark {
    return ThemeData.from(
      colorScheme: const ColorScheme.dark(),
    );
  }
}
